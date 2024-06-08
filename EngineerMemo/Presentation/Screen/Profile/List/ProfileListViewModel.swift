import Combine

final class ProfileListViewModel: ViewModel {
    typealias SortType = DataHolder.ProfileProjectSortType

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapIconChangeButton = PassthroughSubject<ProfileModelObject, Never>()
        let didTapBasicSettingButton = PassthroughSubject<ProfileModelObject?, Never>()
        let didTapSkillSettingButton = PassthroughSubject<ProfileModelObject, Never>()
        let didChangeProjectSortType = PassthroughSubject<SortType, Never>()
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

        cancellables.formUnion([
            // MARK: - DataHolder購読

            DataHolder.$profileProjectSortType.weakSink(with: self) {
                $0.sort(modelObject: output.modelObject, $1)
            },

            // MARK: - viewDidLoad

            input.viewDidLoad
                .flatMap { model.fetch().resultMap }
                .withLatestFrom(DataHolder.$profileProjectSortType) { ($0, $1) }
                .weakSink(with: self) {
                    switch $1.0 {
                    case let .success(modelObjects):
                        $0.sort(modelObject: modelObjects.first, $1.1)

                    case let .failure(appError):
                        output.appError = appError
                    }
                },

            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - プロフィール画像変更ボタンタップ

            input.didTapIconChangeButton.sink {
                routing.showIconScreen(modelObject: $0)
            },

            // MARK: - 基本情報設定ボタンタップ

            input.didTapBasicSettingButton.sink {
                routing.showBasicUpdateScreen(modelObject: $0)
            },

            // MARK: - スキル・経験設定ボタンタップ

            input.didTapSkillSettingButton.sink {
                routing.showSkillUpdateScreen(modelObject: $0)
            },

            // MARK: - 案件・経歴ソート変更

            input.didChangeProjectSortType.sink {
                model.updateProfileProjectSortType($0)
            },

            // MARK: - 案件・経歴作成ボタンタップ

            input.didTapProjectCreateButton.sink {
                routing.showProjectCreateScreen(modelObject: $0)
            },

            // MARK: - 案件詳細セルタップ

            input.didSelectProjectCell.sink {
                routing.showProjectDetailScreen(
                    identifier: $0.0,
                    modelObject: $0.1
                )
            }
        ])
    }
}

// MARK: - private methods

private extension ProfileListViewModel {
    func sort(
        modelObject: ProfileModelObject?,
        _ sortType: SortType
    ) {
        output.modelObject = modelObject.map {
            var modelObject = $0

            modelObject.projects = modelObject.projects.sorted(by: {
                switch sortType {
                case .descending:
                    return $0.startDate ?? .init() > $1.startDate ?? .init()

                case .ascending:
                    return $0.startDate ?? .init() < $1.startDate ?? .init()
                }
            })

            return modelObject
        }
    }
}
