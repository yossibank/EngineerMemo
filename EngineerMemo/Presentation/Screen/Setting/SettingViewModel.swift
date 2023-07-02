import Combine

final class SettingViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {}

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables = Set<AnyCancellable>()

    private let analytics: FirebaseAnalyzable

    init(analytics: FirebaseAnalyzable) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.analytics = analytics

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { _ in
            // NOTE: 初期化時処理
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)
    }
}
