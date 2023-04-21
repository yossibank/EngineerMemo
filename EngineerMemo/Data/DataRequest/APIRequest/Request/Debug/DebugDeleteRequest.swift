import Foundation

struct DebugDeleteRequest: Request {
    typealias Parameters = EmptyParameters
    typealias Response = EmptyResponse

    var method: HTTPMethod { .delete }
    var path: String { "/posts/\(id)" }

    let parameters: Parameters

    private let id: Int

    init(
        parameters: Parameters = .init(),
        pathComponent id: Int
    ) {
        self.parameters = parameters
        self.id = id
    }
}
