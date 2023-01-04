enum APIError: Error, Equatable {
    case decodeError
    case urlSessionError
    case emptyData
    case emptyResponse
    case invalidRequest
    case invalidStatusCode(Int)
    case unknown
}
