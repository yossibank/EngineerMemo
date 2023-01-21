import Combine

final class SampleDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let barButtonTapped = PassthroughSubject<Void, Never>()
    }

    let input: Input
    let output = NoOutput()
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let modelObject: SampleModelObject
    private let routing: SampleDetailRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        modelObject: SampleModelObject,
        routing: SampleDetailRoutingInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()

        self.input = input
        self.modelObject = modelObject
        self.routing = routing
        self.analytics = analytics

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - ナビゲーションボタンタップ

        input.barButtonTapped.sink { _ in
            routing.showEditScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)
    }
}
