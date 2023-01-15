import Combine

final class DebugViewModel: ViewModel {
    final class Input: InputObject {}
    final class Output: OutputObject {}

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let analytics: FirebaseAnalyzable

    init(analytics: FirebaseAnalyzable) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.analytics = analytics
    }
}
