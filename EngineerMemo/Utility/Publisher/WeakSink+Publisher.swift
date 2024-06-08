import Combine

extension Publisher where Failure == Never {
    func weakSink<Owner: AnyObject>(
        with owner: Owner,
        receiveValue: @escaping ((Owner, Output) -> Void)
    ) -> AnyCancellable {
        compactMap { [weak owner] output in
            guard let owner else {
                return nil
            }

            return (owner, output)
        }
        .sink(receiveValue: receiveValue)
    }

    func weakSink<Owner: AnyObject>(
        with owner: Owner,
        cancellables: inout Set<AnyCancellable>,
        receiveValue: @escaping ((Owner, Output) -> Void)
    ) {
        compactMap { [weak owner] output in
            guard let owner else {
                return nil
            }

            return (owner, output)
        }
        .sink(receiveValue: receiveValue)
        .store(in: &cancellables)
    }
}
