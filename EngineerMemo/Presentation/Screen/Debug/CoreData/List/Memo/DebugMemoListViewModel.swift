#if DEBUG
    import Combine

    final class DebugMemoListViewModel: ViewModel {
        final class Input: InputObject {
            let didDeletedModelObject = PassthroughSubject<MemoModelObject, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [MemoModelObject]?
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let model: MemoModelInput

        init(model: MemoModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - メモ情報取得

            model.gets {
                if case let .success(modelObject) = $0 {
                    output.modelObject = modelObject
                }
            }

            // MARK: - メモ情報削除

            input.didDeletedModelObject.sink { modelObject in
                model.delete(modelObject: modelObject)
            }
            .store(in: &cancellables)
        }
    }
#endif
