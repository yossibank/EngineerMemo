import Combine

final class LicenceViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
    }

    let input: Input
    let output = NoOutput()
    let binding = NoBinding()

    private var cancellables = Set<AnyCancellable>()

    private let analytics: FirebaseAnalyzable

    init(analytics: FirebaseAnalyzable) {
        self.input = Input()
        self.analytics = analytics

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)
    }
}
