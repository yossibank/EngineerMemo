import Foundation

extension URL {
    func queryValue(byName query: AppURLScheme.Query) -> String? {
        guard let queryItems = URLComponents(string: absoluteString)?.queryItems else {
            return nil
        }

        return queryItems
            .filter { $0.name == query.rawValue }
            .compactMap(\.value)
            .first
    }
}
