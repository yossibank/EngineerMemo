import Combine

final class ProfileDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapIconChangeButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapBasicEditButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapBasicSettingButton = PassthroughSubject<Void, Never>()
        let didTapSkillEditButton = PassthroughSubject<SkillModelObject, Never>()
        let didTapSkillSettingButton = PassthroughSubject<Void, Never>()
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

        // MARK: - 基本情報編集ボタンタップ

        input.didTapBasicEditButton.sink { modelObject in
            routing.showUpdateBasicScreen(type: .update(modelObject))
        }
        .store(in: &cancellables)

        // MARK: - 基本情報設定ボタンタップ

        input.didTapBasicSettingButton.sink { _ in
            routing.showUpdateBasicScreen(type: .setting)
        }
        .store(in: &cancellables)

        // MARK: - スキル・経験編集ボタンタップ

        input.didTapSkillEditButton.sink { modelObject in
            routing.showUpdateSkillScreen(type: .update(modelObject))
        }
        .store(in: &cancellables)

        // MARK: - スキル・経験設定ボタンタップ

        input.didTapSkillSettingButton.sink { _ in
            routing.showUpdateSkillScreen(type: .setting)
        }
        .store(in: &cancellables)
    }
}
