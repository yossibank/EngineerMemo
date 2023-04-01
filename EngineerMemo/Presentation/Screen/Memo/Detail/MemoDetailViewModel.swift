import Combine

final class MemoDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    let input: Input
    let output = NoOutput()
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let analytics: FirebaseAnalyzable

    init(analytics: FirebaseAnalyzable) {
        let input = Input()

        self.input = input
        self.analytics = analytics

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)
    }
}
