#if DEBUG
    import Combine

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let contentTapped = PassthroughSubject<DebugCoreDataItem, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let routing: DebugDevelopmentRoutingInput

        init(routing: DebugDevelopmentRoutingInput) {
            self.input = Input()
            self.routing = routing

            // MARK: - セルタップ

            input.contentTapped.sink { item in
                routing.showDebugCoreDataScreen(item: item)
            }
            .store(in: &cancellables)
        }
    }
#endif
