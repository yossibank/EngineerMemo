import Combine

final class ProfileDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapEditButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapSettingButton = PassthroughSubject<Void, Never>()
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
    private let routing: ProfileDetailRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        routing: ProfileDetailRoutingInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.routing = routing
        self.analytics = analytics

        // MARK: - viewDidLoad

        input.viewDidLoad
            .sink { _ in
                model.get { result in
                    switch result {
                    case let .failure(appError):
                        output.appError = appError

                    case let .success(modelObject):
                        output.modelObject = modelObject
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

        // MARK: - 編集ボタンタップ

        input.didTapEditButton
            .sink { modelObject in
                routing.showUpdateScreen(type: .update(modelObject))
            }
            .store(in: &cancellables)

        // MARK: - 設定ボタンタップ

        input.didTapSettingButton
            .sink { _ in
                routing.showUpdateScreen(type: .setting)
            }
            .store(in: &cancellables)
    }
}
