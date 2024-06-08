import Foundation

enum ErrorType: Equatable {
    case something(String?)
    case timeout
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
            case .decodeError, .emptyData, .emptyResponse, .invalidRequest: .something(errorDescription)
            case .timeoutError: .timeout
            case .urlSessionError: .urlSession
            case let .invalidStatusCode(code): .invalidStatusCode(code)
            case .unknown: .unknown
            }

        case let .coreData(coreDataError):
            switch coreDataError {
            case .something: .something(errorDescription)
            }
        }
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch dataError {
        case let .api(apiError): apiError.errorDescription
        case let .coreData(coreDataError):
            switch coreDataError {
            case let .something(description): description
            }
        }
    }
}
