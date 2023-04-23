import Foundation

enum APIError: Error, Equatable {
    case decodeError
    case urlSessionError
    case emptyData
    case emptyResponse
    case invalidRequest
    case invalidStatusCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodeError:
            return "デコードエラーです"

        case .urlSessionError:
            return "URLSessionエラーです"

        case .emptyData:
            return "空のデータです"

        case .emptyResponse:
            return "空のレスポンスです"

        case .invalidRequest:
            return "無効なリクエストです"

        case let .invalidStatusCode(code):
            return "無効なステータスコード【\(code.description)】です"

        case .unknown:
            return "不明なエラーです"
        }
    }
}
