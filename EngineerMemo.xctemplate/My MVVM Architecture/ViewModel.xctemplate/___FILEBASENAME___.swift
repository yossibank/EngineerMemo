import Combine

final class ___FILEBASENAME___: ViewModel {
    // 不要な場合はNoBinding使用
    final class Binding: BindingObject {
        @Published var sample = ""
    }

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {}

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output
    // let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let analytics: FirebaseAnalyzable

    init(analytics: FirebaseAnalyzable) {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
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
