#if DEBUG
    import Combine

    final class DebugProfileListViewModel: ViewModel {
        final class Input: InputObject {
            let viewDidLoad = PassthroughSubject<Void, Never>()
            let didSwipe = PassthroughSubject<ProfileModelObject, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [ProfileModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
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
                        if case let .success(modelObjects) = $1 {
                            output.modelObjects = modelObjects
                        }
                    },

                // MARK: - プロフィール情報削除

                input.didSwipe.weakSink(with: self) {
                    $0.deleteProfile($1)
                }
            ])
        }
    }

    // MARK: - private methods

    private extension DebugProfileListViewModel {
        func deleteProfile(_ modelObject: ProfileModelObject) {
            model.delete(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
