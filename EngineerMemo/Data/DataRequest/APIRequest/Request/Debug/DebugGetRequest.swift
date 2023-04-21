#if DEBUG
    import Foundation

    struct DebugGetRequest: Request {
        typealias Response = [DebugDataObject]
        typealias PathComponent = EmptyPathComponent

        struct Parameters: Encodable {
            let userId: Int?
        }

        var method: HTTPMethod { .get }
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
