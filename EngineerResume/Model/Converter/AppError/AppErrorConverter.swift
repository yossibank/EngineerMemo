/// @mockable
protocol AppErrorConverterInput {
    func convert(_ dataError: DataError) -> AppError
}

struct AppErrorConverter: AppErrorConverterInput {
    func convert(_ dataError: DataError) -> AppError {
        .init(dataError: dataError)
    }
}
