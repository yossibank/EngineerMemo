import Foundation

struct SamplePostRequest: Request {
    typealias Response = SampleDataObject
    typealias PathComponent = EmptyPathComponent

    struct Parameters: Codable {
        let userId: Int
        let title: String
        let body: String
    }

    let parameters: Parameters
    var method: HTTPMethod { .post }
    var path: String { "/posts" }

    var queryItems: [URLQueryItem]?

    init(
        parameters: Parameters,
        pathComponent: PathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
