import Combine

final class SettingViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didChangeColorThemeIndex = PassthroughSubject<Int, Never>()
        let didTapApplicationCell = PassthroughSubject<SettingContentViewItem.Application, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var didTapReview = false
        @Published fileprivate(set) var didTapInquiry = false
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables = Set<AnyCancellable>()

    private let model: SettingModelInput
    private let routing: SettingRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        model: SettingModelInput,
        routing: SettingRoutingInput,
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
            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - カラーテーマセグメント変更

            input.didChangeColorThemeIndex.sink {
                model.updateColorTheme($0)
            },

            // MARK: - アプリケーションセルタップ

            input.didTapApplicationCell.sink {
                switch $0 {
                case .review:
                    output.didTapReview = true

                case .inquiry:
                    output.didTapInquiry = true

                case .licence:
                    routing.showLicenceScreen()

                default:
                    break
                }
            }
        ])
    }
}
