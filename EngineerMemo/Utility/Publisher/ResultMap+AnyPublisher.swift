import Combine

extension AnyPublisher {
    var resultMap: AnyPublisher<Result<Output, Failure>, Never> {
        map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}
