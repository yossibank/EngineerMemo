import Foundation

struct SampleGetRequest: Request {
    typealias Response = [SampleDataObject]
    typealias PathComponent = EmptyPathComponent

    struct Parameters: Codable {
        let userId: Int?
    }

    let parameters: Parameters
    var method: HTTPMethod { .get }
    var path: String { "/posts" }

    var body: Data?

    init(
        parameters: Parameters,
        pathComponent: PathComponent = .init()
    ) {
        self.parameters = parameters
    }
}
