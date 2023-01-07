#if DEBUG
    final class AppErrorBuilder {
        private var dataError: DataError = .api(.unknown)

        func build() -> AppError {
            .init(dataError: dataError)
        }

        func dataError(_ dataError: DataError) -> Self {
            self.dataError = dataError
            return self
        }
    }
#endif
