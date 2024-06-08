import Combine

final class ProjectDetailViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapEditBarButton = PassthroughSubject<Void, Never>()
        let didTapDeleteBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: ProjectModelObject?
        @Published fileprivate(set) var appError: AppError?
        @Published fileprivate(set) var isDeleted = false
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var modelObject: ProfileModelObject?
    private var cancellables = Set<AnyCancellable>()

    private let model: ProfileModelInput
    private let routing: ProjectDetailRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        identifier: String,
        modelObject: ProfileModelObject,
        model: ProfileModelInput,
        routing: ProjectDetailRoutingInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.routing = routing
        self.analytics = analytics

        cancellables.formUnion([
            // MARK: - viewDidLoad

            input.viewDidLoad
                .flatMap { model.find(identifier: modelObject.identifier).resultMap }
                .weakSink(with: self) {
                    switch $1 {
                    case let .success(modelObject):
                        output.modelObject = modelObject.projects
                            .filter { $0.identifier == identifier }
                            .first

                        $0.modelObject = modelObject

                    case let .failure(appError):
                        output.appError = appError
                    }
                },

            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - 編集ボタンタップ

            input.didTapEditBarButton.weakSink(with: self) {
                if let modelObject = $0.modelObject {
                    routing.showUpdateScreen(
                        identifier: identifier,
                        modelObject: modelObject
                    )
                }
            },

            // MARK: - 削除ボタンタップ

            input.didTapDeleteBarButton.weakSink(with: self) {
                if let modelObject = $0.modelObject {
                    $0.deleteProject(modelObject, identifier: identifier)
                    output.isDeleted = true
                }
            }
        ])
    }
}

// MARK: - private methods

private extension ProjectDetailViewModel {
    func deleteProject(
        _ modelObject: ProfileModelObject,
        identifier: String
    ) {
        model.deleteProject(modelObject, identifier: identifier)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
