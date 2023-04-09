import Combine

final class MemoDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    let input: Input
    let output = NoOutput()
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let modelObject: MemoModelObject
    private let routing: MemoDetailRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        modelObject: MemoModelObject,
        routing: MemoDetailRoutingInput,
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

        // MARK: - 編集ボタンタップ

        input.didTapBarButton.sink {
            routing.showUpdateScreen(modelObject: modelObject)
        }
        .store(in: &cancellables)
    }
}
