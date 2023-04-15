import Combine

final class MemoDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapEditBarButton = PassthroughSubject<Void, Never>()
        let didTapDeleteBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: MemoModelObject?
        @Published fileprivate(set) var appError: AppError?
        @Published fileprivate(set) var isDeleted = false
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let identifier: String
    private let model: MemoModelInput
    private let routing: MemoDetailRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        identifier: String,
        model: MemoModelInput,
        routing: MemoDetailRoutingInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.identifier = identifier
        self.model = model
        self.routing = routing
        self.analytics = analytics

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { _ in
            model.find(identifier: identifier) {
                switch $0 {
                case let .success(modelObject):
                    output.modelObject = modelObject

                case let .failure(appError):
                    output.appError = appError
                }
            }
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 編集ボタンタップ

        input.didTapEditBarButton.sink {
            if let modelObject = output.modelObject {
                routing.showUpdateScreen(modelObject: modelObject)
            }
        }
        .store(in: &cancellables)

        // MARK: - 削除ボタンタップ

        input.didTapDeleteBarButton.sink {
            if let modelObject = output.modelObject {
                model.delete(modelObject: modelObject)
                output.isDeleted = true
            }
        }
        .store(in: &cancellables)
    }
}
