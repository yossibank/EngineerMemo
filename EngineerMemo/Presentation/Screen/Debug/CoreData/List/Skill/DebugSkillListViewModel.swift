#if DEBUG
    import Combine

    final class DebugSkillListViewModel: ViewModel {
        final class Input: InputObject {
            let viewDidLoad = PassthroughSubject<Void, Never>()
            let didDeletedModelObject = PassthroughSubject<ProfileModelObject, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [ProfileModelObject] = []
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

            // MARK: - viewDidLoad

            input.viewDidLoad.sink { _ in
                model.fetch {
                    if case let .success(modelObject) = $0 {
                        output.modelObject = modelObject.filter {
                            $0.skill != nil
                        }
                    }
                }
            }
            .store(in: &cancellables)

            // MARK: - スキル情報削除

            input.didDeletedModelObject.sink {
                var modelObject = $0
                modelObject.skill = nil

                model.skillUpdate(modelObject: modelObject)
            }
            .store(in: &cancellables)
        }
    }
#endif
