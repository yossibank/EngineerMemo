import Foundation

struct SamplePutRequest: Request {
    typealias Response = SampleDataObject

    struct Parameters: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }

    private let id: Int

    let parameters: Parameters
    var method: HTTPMethod { .put }
    var path: String { "/posts/\(id)" }

    var queryItems: [URLQueryItem]?

    init(
        parameters: Parameters,
        pathComponent id: Int
    ) {
        self.parameters = parameters
        self.id = id
    }
}
