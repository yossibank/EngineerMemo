import Combine

final class ProfileDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: ProfileModelObject?
        @Published fileprivate(set) var appError: AppError?
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics

        // MARK: - プロフィール情報取得

        model.get { result in
            switch result {
            case let .failure(appError):
                output.appError = appError

            case let .success(modelObject):
                output.modelObject = modelObject
            }
        }

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)
    }
}
