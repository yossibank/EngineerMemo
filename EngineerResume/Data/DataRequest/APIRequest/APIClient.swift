import Foundation

/// @mockable
protocol APIClientInput {
    func request<T>(
        item: some Request<T>,
        completion: @escaping (Result<T, APIError>) -> Void
    )
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
            guard error == nil else {
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

            let value = try decoder.decode(T.self, from: data)
            completion(.success(value))
        } catch {
            completion(.failure(.decodeError))
        }
    }
}
