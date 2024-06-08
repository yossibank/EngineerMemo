import Combine

extension Publisher where Failure == Never {
    func weakSink<Owner: AnyObject>(
        with owner: Owner,
        _ receiveValue: @escaping ((Owner, Output) -> Void)
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
        _ receiveValue: @escaping ((Owner) -> Void)
    ) -> AnyCancellable {
        compactMap { [weak owner] _ in
            guard let owner else {
                return nil
            }

            return owner
        }
        .sink(receiveValue: receiveValue)
    }

    func weakSink<Owner: AnyObject>(
        with owner: Owner,
        cancellables: inout Set<AnyCancellable>,
        _ receiveValue: @escaping ((Owner, Output) -> Void)
    ) {
        weakSink(with: owner, receiveValue)
            .store(in: &cancellables)
    }

    func weakSink<Owner: AnyObject>(
        with owner: Owner,
        cancellables: inout Set<AnyCancellable>,
        _ receiveValue: @escaping ((Owner) -> Void)
    ) {
        weakSink(with: owner, receiveValue)
            .store(in: &cancellables)
    }
}
