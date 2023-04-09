import Foundation

struct EmptyParameters: Encodable, Equatable {}
struct EmptyResponse: Codable, Equatable {}
struct EmptyPathComponent {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Request<Response> {
    associatedtype Response: Decodable
    associatedtype Parameters: Encodable
    associatedtype PathComponent

    // 必須要素
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var path: String { get }

    // オプション要素
    var baseURL: String { get }
    var body: Data? { get }
    var timeoutInterval: TimeInterval { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }

    init(
        parameters: Parameters,
        pathComponent: PathComponent
    )
}

extension Request {
    var baseURL: String {
        DataConfig.baseURL
    }

    var body: Data? {
        try? JSONEncoder().encode(parameters)
    }

    var timeoutInterval: TimeInterval {
        10.0
    }

    var headers: [String: String] {
        var dic: [String: String] = [:]

        APIRequestHeader.allCases.forEach { header in
            dic[header.rawValue] = header.value
        }

        return dic
    }

    var queryItems: [URLQueryItem]? {
        let query: [URLQueryItem]

        if let p = parameters as? [Encodable] {
            query = p.flatMap { param in
                param.dictionary.map { key, value in
                    URLQueryItem(
                        name: key,
                        value: value?.description ?? .empty
                    )
                }
            }
        } else {
            query = parameters.dictionary.map { key, value in
                URLQueryItem(
                    name: key,
                    value: value?.description ?? .empty
                )
            }
        }

        return query.sorted { first, second in
            first.name < second.name
        }
    }
}

private extension Encodable {
    var dictionary: [String: CustomStringConvertible?] {
        (
            try? JSONSerialization.jsonObject(
                with: JSONEncoder().encode(self)
            )
        ) as? [String: CustomStringConvertible?] ?? [:]
    }
}
