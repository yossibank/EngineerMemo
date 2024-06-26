#if DEBUG
    import Combine

    final class DebugMemoListViewModel: ViewModel {
        final class Input: InputObject {
            let viewDidLoad = PassthroughSubject<Void, Never>()
            let didSwipe = PassthroughSubject<MemoModelObject, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [MemoModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()

        private let model: MemoModelInput

        init(model: MemoModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            cancellables.formUnion([
                // MARK: - viewDidLoad

                input.viewDidLoad
                    .flatMap { model.fetch().resultMap }
                    .weakSink(with: self) {
                        if case let .success(modelObject) = $1 {
                            output.modelObject = modelObject
                        }
                    },

                // MARK: - メモ情報削除

                input.didSwipe.weakSink(with: self) {
                    $0.deleteMemo($1)
                }
            ])
        }
    }

    // MARK: - private methods

    private extension DebugMemoListViewModel {
        func deleteMemo(_ modelObject: MemoModelObject) {
            model.delete(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
