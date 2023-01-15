#if DEBUG
    import Combine

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let contentTapped = PassthroughSubject<Int, Never>()
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

            input.contentTapped.sink { row in
                Logger.debug(message: row.description)
                routing.showDebugCoreDataScreen()
            }
            .store(in: &cancellables)
        }
    }
#endif
