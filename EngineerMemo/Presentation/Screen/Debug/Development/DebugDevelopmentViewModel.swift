#if DEBUG
    import Combine

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let coreDataTapped = PassthroughSubject<DebugCoreDataAction, Never>()
            let userDefaultsTapped = PassthroughSubject<Void, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let routing: DebugDevelopmentRoutingInput

        init(routing: DebugDevelopmentRoutingInput) {
            self.input = Input()
            self.routing = routing

            // MARK: - CoreDataセルタップ

            input.coreDataTapped.sink { action in
                routing.showDebugCoreDataScreen(action: action)
            }
            .store(in: &cancellables)

            // MARK: - UserDefaultsセルタップ

            input.userDefaultsTapped.sink {
                routing.showDebugUserDefaultsScreen()
            }
            .store(in: &cancellables)
        }
    }
#endif
