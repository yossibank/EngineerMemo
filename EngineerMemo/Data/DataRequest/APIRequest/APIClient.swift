import Combine
import Foundation

/// @mockable
protocol APIClientInput {
    func request<T>(
        item: some Request<T>,
        completion: @escaping (Result<T, APIError>) -> Void
    )

    func request<T>(item: some Request<T>) -> AnyPublisher<T, APIError>

    func request<T>(item: some Request<T>) async throws -> T
}

struct APIClient: APIClientInput {
    func request<T>(
        item: some Request<T>,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let urlRequest = createURLRequest(item) else {
            completion(.failure(.invalidRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error.isNil else {
                completion(.failure(.urlSessionError))
                return
            }

            guard let data else {
                completion(.failure(.emptyData))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.emptyResponse))
                return
            }

            guard (200 ... 299).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }

            decode(
                data: data,
                completion: completion
            )
        }

        task.resume()
    }

    func request<T>(item: some Request<T>) -> AnyPublisher<T, APIError> {
        let decoder: JSONDecoder = {
            $0.keyDecodingStrategy = .convertFromSnakeCase
            return $0
        }(JSONDecoder())

        guard let urlRequest = createURLRequest(item) else {
            return Deferred {
                Future<T, APIError> {
                    $0(.failure(.invalidRequest))
                }
            }
            .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.emptyResponse
                }

                guard (200 ... 299).contains(response.statusCode) else {
                    throw APIError.invalidStatusCode(response.statusCode)
                }

                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { APIError.parse($0) }
            .eraseToAnyPublisher()
    }

    func request<T>(item: some Request<T>) async throws -> T {
        guard let urlRequest = createURLRequest(item) else {
            throw APIError.invalidRequest
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw APIError.emptyResponse
            }

            guard (200 ... 299).contains(response.statusCode) else {
                throw APIError.invalidStatusCode(response.statusCode)
            }

            let decoder: JSONDecoder = {
                $0.keyDecodingStrategy = .convertFromSnakeCase
                return $0
            }(JSONDecoder())

            let value = try decoder.decode(
                T.self,
                from: data
            )

            return value
        } catch {
            throw APIError.parse(error)
        }
    }
}

private extension APIClient {
    func createURLRequest(_ requestItem: some Request) -> URLRequest? {
        guard let fullPath = URL(string: requestItem.baseURL + requestItem.path) else {
            return nil
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = fullPath.scheme
        urlComponents.host = fullPath.host
        urlComponents.path = fullPath.path
        urlComponents.port = fullPath.port
        urlComponents.queryItems = requestItem.queryItems

        guard let url = urlComponents.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = requestItem.timeoutInterval
        urlRequest.httpMethod = requestItem.method.rawValue
        urlRequest.httpBody = requestItem.body

        requestItem.headers.forEach {
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }

        Logger.debug(message: urlRequest.curlString)

        return urlRequest
    }

    func decode<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        do {
            let decoder: JSONDecoder = {
                $0.keyDecodingStrategy = .convertFromSnakeCase
                return $0
            }(JSONDecoder())

            let value = try decoder.decode(
                T.self,
                from: data
            )
            completion(.success(value))
        } catch {
            completion(.failure(.decodeError))
        }
    }
}
