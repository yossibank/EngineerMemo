import Combine

final class ProfileDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapIconChangeButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapBasicSettingButton = PassthroughSubject<ProfileModelObject?, Never>()
        let didTapSkillSettingButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapProjectSettingButton = PassthroughSubject<ProfileModelObject, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: ProfileModelObject?
        @Published fileprivate(set) var appError: AppError?
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables = Set<AnyCancellable>()

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

        input.viewDidLoad.sink { _ in
            model.fetch {
                switch $0 {
                case let .success(modelObjects):
                    output.modelObject = modelObjects.first

                case let .failure(appError):
                    output.appError = appError
                }
            }
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - プロフィール画像変更ボタンタップ

        input.didTapIconChangeButton.sink { modelObject in
            routing.showIconScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)

        // MARK: - 基本情報設定ボタンタップ

        input.didTapBasicSettingButton.sink { modelObject in
            routing.showUpdateBasicScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)

        // MARK: - スキル・経験設定ボタンタップ

        input.didTapSkillSettingButton.sink { modelObject in
            routing.showUpdateSkillScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)

        // MARK: - 案件・経歴設定ボタンタップ

        input.didTapProjectSettingButton.sink { modelObject in
            routing.showUpdateProjectScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)
    }
}
