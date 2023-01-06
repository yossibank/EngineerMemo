import Foundation

enum ErrorType: Equatable {
    case something(String?)
    case urlSession
    case invalidStatusCode(Int)
    case unknown
}

enum DataError: Error, Equatable {
    case api(APIError)
    case coreData(CoreDataError)
}

struct AppError: Error, Equatable {
    private let dataError: DataError

    init(dataError: DataError) {
        self.dataError = dataError
    }
}

extension AppError {
    var errorType: ErrorType {
        switch dataError {
        case let .api(apiError):
            switch apiError {
            case .decodeError, .emptyData, .emptyResponse, .invalidRequest:
                return .something(errorDescription)

            case .urlSessionError:
                return .urlSession

            case let .invalidStatusCode(code):
                return .invalidStatusCode(code)

            case .unknown:
                return .unknown
            }

        case let .coreData(coreDataError):
            switch coreDataError {
            case .something:
                return .something(errorDescription)
            }
        }
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch dataError {
        case let .api(apiError):
            switch apiError {
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

        case let .coreData(coreDataError):
            switch coreDataError {
            case let .something(description):
                return description
            }
        }
    }
}
