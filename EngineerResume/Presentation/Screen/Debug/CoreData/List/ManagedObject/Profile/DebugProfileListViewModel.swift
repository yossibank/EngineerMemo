#if DEBUG
    import Combine

    final class DebugProfileListViewModel: ViewModel {
        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [ProfileModelObject]?
        }

        let input = NoInput()
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let output = Output()

            self.output = output
            self.model = model

            // MARK: - プロフィール情報取得

            model.gets {
                if case let .success(modelObject) = $0 {
                    output.modelObject = modelObject
                }
            }
        }
    }
#endif
