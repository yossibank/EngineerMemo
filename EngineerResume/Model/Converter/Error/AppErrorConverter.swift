/// @mockable
protocol AppErrorConverterInput {
    func convert(_ error: APIError) -> AppError
}

struct AppErrorConverter: AppErrorConverterInput {
    func convert(_ error: APIError) -> AppError {
        .init(error: error)
    }
}
