import Foundation

enum ErrorType: Equatable {
    case something(String?)
    case urlSession
    case invalidStatusCode(Int)
    case unknown
}

struct AppError: Error, Equatable {
    private let error: APIError

    init(error: APIError) {
        self.error = error
    }
}

extension AppError {
    var errorType: ErrorType {
        switch error {
        case .decodeError, .emptyData, .emptyResponse, .invalidRequest:
            return .something(errorDescription)

        case .urlSessionError:
            return .urlSession

        case let .invalidStatusCode(code):
            return .invalidStatusCode(code)

        case .unknown:
            return .unknown
        }
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch error {
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
