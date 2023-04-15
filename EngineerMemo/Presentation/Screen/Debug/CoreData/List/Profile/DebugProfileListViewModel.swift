#if DEBUG
    import Combine

    final class DebugProfileListViewModel: ViewModel {
        final class Input: InputObject {
            let didDeletedModelObject = PassthroughSubject<ProfileModelObject, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [ProfileModelObject]?
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - プロフィール情報取得

            model.fetch {
                if case let .success(modelObject) = $0 {
                    output.modelObject = modelObject
                }
            }

            // MARK: - プロフィール情報削除

            input.didDeletedModelObject.sink { modelObject in
                model.delete(modelObject: modelObject)
            }
            .store(in: &cancellables)
        }
    }
#endif
