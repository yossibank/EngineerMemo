import Combine

final class DebugUserDefaultsViewModel: ViewModel {
    // 不要な場合はNoBinding使用
    final class Binding: BindingObject {
        @Published var sample = ""
    }

    final class Input: InputObject {}
    final class Output: OutputObject {}

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output
    // let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    init() {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
        self.input = input
        self.output = output
    }
}
