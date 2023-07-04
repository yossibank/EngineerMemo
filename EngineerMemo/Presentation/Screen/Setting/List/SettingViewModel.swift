import Combine

final class SettingViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didChangeColorThemeIndex = PassthroughSubject<Int, Never>()
        let didTapReviewCell = PassthroughSubject<Void, Never>()
        let didTapLicenceCell = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var didTapReview = false
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

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - カラーテーマセグメント変更

        input.didChangeColorThemeIndex.sink {
            model.updateColorTheme($0)
        }
        .store(in: &cancellables)

        // MARK: - レビューセルタップ

        input.didTapReviewCell.sink {
            output.didTapReview = true
        }
        .store(in: &cancellables)

        // MARK: - ライセンスセルタップ

        input.didTapLicenceCell.sink {
            routing.showLicenceScreen()
        }
        .store(in: &cancellables)
    }
}
