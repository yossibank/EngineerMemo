import Combine

final class ProfileListViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapIconChangeButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapBasicSettingButton = PassthroughSubject<ProfileModelObject?, Never>()
        let didTapSkillSettingButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapProjectCreateButton = PassthroughSubject<ProfileModelObject, Never>()
        let didSelectProjectCell = PassthroughSubject<(String, ProfileModelObject), Never>()
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
    private let routing: ProfileListRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        routing: ProfileListRoutingInput,
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
            .flatMap { model.fetch().resultMap }
            .sink {
                switch $0 {
                case let .success(modelObjects):
                    output.modelObject = modelObjects.first

                case let .failure(appError):
                    output.appError = appError
                }
            }
            .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - プロフィール画像変更ボタンタップ

        input.didTapIconChangeButton.sink {
            routing.showIconScreen(modelObject: $0)
        }
        .store(in: &cancellables)

        // MARK: - 基本情報設定ボタンタップ

        input.didTapBasicSettingButton.sink {
            routing.showBasicUpdateScreen(modelObject: $0)
        }
        .store(in: &cancellables)

        // MARK: - スキル・経験設定ボタンタップ

        input.didTapSkillSettingButton.sink {
            routing.showSkillUpdateScreen(modelObject: $0)
        }
        .store(in: &cancellables)

        // MARK: - 案件・経歴作成ボタンタップ

        input.didTapProjectCreateButton.sink {
            routing.showProjectCreateScreen(modelObject: $0)
        }
        .store(in: &cancellables)

        // MARK: - 案件詳細セルタップ

        input.didSelectProjectCell.sink {
            routing.showProjectDetailScreen(
                identifier: $0.0,
                modelObject: $0.1
            )
        }
        .store(in: &cancellables)
    }
}
