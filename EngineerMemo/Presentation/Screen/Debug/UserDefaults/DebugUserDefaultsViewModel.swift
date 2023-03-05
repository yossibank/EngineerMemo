#if DEBUG
    import Combine

    final class DebugUserDefaultsViewModel: ViewModel {
        final class Input: InputObject {
            let selectedTypeChanged = PassthroughSubject<DebugUserDefaultsMenuType, Never>()
            let segmentControlChanged = PassthroughSubject<Int, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var description: String?
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let model = DebugModel()

        init() {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output

            // MARK: - セグメント変更

            input.segmentControlChanged
                .withLatestFrom(input.selectedTypeChanged) { ($0, $1) }
                .sink { [weak self] index, menuType in
                    switch menuType {
                    case .sample:
                        self?.model.updateSample(.init(rawValue: index)!)
                        self?.output.description = DataHolder.sample.description

                    case .test:
                        self?.model.updateTest(.init(rawValue: index)!)
                        self?.output.description = DataHolder.test.description
                    }
                }
                .store(in: &cancellables)
        }
    }
#endif
