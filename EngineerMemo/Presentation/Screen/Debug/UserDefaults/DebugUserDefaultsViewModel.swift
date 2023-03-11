#if DEBUG
    import Combine

    final class DebugUserDefaultsViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeUserDefaultsKey = PassthroughSubject<UserDefaultsKey, Never>()
            let didChangeSegmentIndex = PassthroughSubject<Int, Never>()
            let didChangeInputText = PassthroughSubject<String, Never>()
            let didTapNilButton = PassthroughSubject<Void, Never>()
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

                    case .bool:
                        self?.model.updateBool(index.boolValue)
                        self?.output.description = DataHolder.bool.description

                    case .optionalBool:
                        self?.model.updateOptionalBool(index.optionalBoolValue)
                        self?.output.description = DataHolder.optionalBool?.description ?? .nilWord

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
                    case .string:
                        self?.model.updateString(text)
                        self?.output.description = DataHolder.string.isEmpty
                            ? .emptyWord
                            : DataHolder.string

                    case .int:
                        guard let value = Int(text) else {
                            return
                        }

                        self?.model.updateInt(value)
                        self?.output.description = DataHolder.int.description

                    case .optional:
                        self?.model.updateOptional(text)

                        let value: String? = {
                            guard let value = DataHolder.optional else {
                                return nil
                            }

                            if DataHolder.optional.isNil {
                                return .nilWord
                            }

                            return value.isEmpty ? .emptyWord : value
                        }()

                        self?.output.description = value

                    default:
                        break
                    }
                }
                .store(in: &cancellables)

            // MARK: - nilボタンタップ

            input.didTapNilButton
                .withLatestFrom(input.didChangeUserDefaultsKey)
                .sink { [weak self] key in
                    switch key {
                    case .optional:
                        self?.model.updateOptional(nil)
                        self?.output.description = .nilWord

                    default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
    }
#endif
