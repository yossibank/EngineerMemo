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

            // MARK: - viewDidLoad

            input.viewDidLoad
                .flatMap { model.fetch().resultMap }
                .sink {
                    if case let .success(modelObject) = $0 {
                        output.modelObject = modelObject
                    }
                }
                .store(in: &cancellables)

            // MARK: - メモ情報削除

            input.didSwipe.sink { modelObject in
                model.delete(modelObject)
            }
            .store(in: &cancellables)
        }
    }
#endif
