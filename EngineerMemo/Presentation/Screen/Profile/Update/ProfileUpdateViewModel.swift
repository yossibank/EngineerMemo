import Combine

final class ProfileUpdateViewModel: ViewModel {
    final class Input: InputObject {}
    final class Output: OutputObject {}

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics
    }
}
