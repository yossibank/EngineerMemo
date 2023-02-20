#if DEBUG
    import Combine

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let contentTapped = PassthroughSubject<DebugCoreDataAction, Never>()
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

            input.contentTapped.sink { action in
                routing.showDebugCoreDataScreen(action: action)
            }
            .store(in: &cancellables)
        }
    }
#endif
