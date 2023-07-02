import Combine

final class SettingViewModel: ViewModel {
    final class Input: InputObject {
        let didChangeColorThemeIndex = PassthroughSubject<Int, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    let input: Input
    let output = NoOutput()
    let binding = NoBinding()

    private var cancellables = Set<AnyCancellable>()

    private let model: SettingModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: SettingModelInput,
        analytics: FirebaseAnalyzable
    ) {
        self.input = Input()
        self.model = model
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
    }
}
