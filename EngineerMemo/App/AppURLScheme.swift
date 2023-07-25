import Foundation
import UIKit

enum AppURLScheme: String {
    case memoDetail = "memo-detail"
    case memoCreate = "memo-create"

    enum Query: String {
        case identifier
    }

    enum QueryItem {
        case identifier(String)

        var dictionary: [String: String?] {
            switch self {
            case let .identifier(identifier):
                return ["identifier": identifier]
            }
        }
    }

    func schemeURL(queryItems: [QueryItem] = []) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "engineermemo"
        urlComponents.host = rawValue
        urlComponents.queryItems = queryItems.flatMap(\.dictionary).map {
            .init(name: $0.key, value: $0.value)
        }
        return urlComponents.url
    }
}
