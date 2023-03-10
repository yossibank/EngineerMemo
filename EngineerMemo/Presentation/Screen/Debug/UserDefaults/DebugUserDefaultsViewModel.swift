#if DEBUG
    import Combine

    final class DebugUserDefaultsViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeUserDefaultsKey = PassthroughSubject<UserDefaultsKey, Never>()
            let didChangeSegmentIndex = PassthroughSubject<Int, Never>()
            let didChangeInputText = PassthroughSubject<String, Never>()
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

            input.didChangeSegmentIndex
                .withLatestFrom(input.didChangeUserDefaultsKey) { ($0, $1) }
                .sink { [weak self] index, key in
                    switch key {
                    case .sample:
                        self?.model.updateSample(.init(rawValue: index)!)
                        self?.output.description = DataHolder.sample.description

                    case .test:
                        self?.model.updateTest(.init(rawValue: index)!)
                        self?.output.description = DataHolder.test.description

                    default:
                        break
                    }
                }
                .store(in: &cancellables)

            // MARK: - テキストフィールド文字変更

            input.didChangeInputText
                .withLatestFrom(input.didChangeUserDefaultsKey) { ($0, $1) }
                .sink { [weak self] text, key in
                    switch key {
                    case .textField:
                        self?.model.updateTextField(text)
                        self?.output.description = DataHolder.textField.description

                    default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
    }
#endif
