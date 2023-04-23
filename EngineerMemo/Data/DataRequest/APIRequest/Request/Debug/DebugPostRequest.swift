#if DEBUG
    import Foundation

    struct DebugPostRequest: Request {
        typealias Response = DebugDataObject
        typealias PathComponent = EmptyPathComponent

        struct Parameters: Encodable {
            let userId: Int
            let title: String
            let body: String
        }

        var method: HTTPMethod { .post }
        var path: String { "/posts" }

        let parameters: Parameters

        init(
            parameters: Parameters,
            pathComponent: PathComponent = .init()
        ) {
            self.parameters = parameters
        }
    }
#endif
