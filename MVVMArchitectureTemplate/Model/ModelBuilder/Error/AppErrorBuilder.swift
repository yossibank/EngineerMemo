#if DEBUG
    final class AppErrorBuilder {
        private var error: APIError = .unknown

        func build() -> AppError {
            .init(error: error)
        }

        func error(_ error: APIError) -> Self {
            self.error = error
            return self
        }
    }
#endif
