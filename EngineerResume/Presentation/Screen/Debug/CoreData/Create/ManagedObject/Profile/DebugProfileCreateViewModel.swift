import Combine

final class DebugProfileCreateViewModel: ViewModel {
    final class Input: InputObject {}
    final class Output: OutputObject {}

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
    }
}
