#if DEBUG
    import Combine

    final class DebugSkillListViewModel: ViewModel {
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

            // MARK: - viewDidLoad

            input.viewDidLoad
                .flatMap { model.fetch().resultMap }
                .sink {
                    if case let .success(modelObjects) = $0 {
                        output.modelObjects = modelObjects.filter {
                            $0.skill != nil
                        }
                    }
                }
                .store(in: &cancellables)

            // MARK: - スキル情報削除

            input.didSwipe.sink { [weak self] in
                self?.deleteSkill($0)
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugSkillListViewModel {
        func deleteSkill(_ modelObject: ProfileModelObject) {
            model.deleteSkill(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
