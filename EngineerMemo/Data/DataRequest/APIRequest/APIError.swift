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

extension APIError {
    static func parse(_ error: Error) -> APIError {
        guard error as? DecodingError == nil else {
            return .decodeError
        }

        guard error._code != -1009 else {
            return .urlSessionError
        }

        guard let apiError = error as? APIError else {
            return .unknown
        }

        return apiError
    }
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
