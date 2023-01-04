import Foundation

struct SampleDeleteRequest: Request {
    typealias Parameters = EmptyParameters
    typealias Response = EmptyResponse

    private let id: Int

    let parameters: Parameters
    var method: HTTPMethod { .delete }
    var path: String { "/posts/\(id)" }

    var body: Data?
    var queryItems: [URLQueryItem]?

    init(
        parameters: Parameters = .init(),
        pathComponent id: Int
    ) {
        self.parameters = parameters
        self.id = id
    }
}
