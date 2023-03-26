import Combine

final class MemoListViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObjects: [MemoModelObject] = []
        @Published fileprivate(set) var appError: AppError?
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let model: MemoModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: MemoModelInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics

        // MARK: - viewDidLoad

        input.viewDidLoad
            .sink { _ in
                model.gets {
                    switch $0 {
                    case let .failure(appError):
                        output.appError = appError

                    case let .success(modelObjects):
                        output.modelObjects = modelObjects
                    }
                }
            }
            .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear
            .sink { _ in
                analytics.sendEvent(.screenView)
            }
            .store(in: &cancellables)
    }
}
