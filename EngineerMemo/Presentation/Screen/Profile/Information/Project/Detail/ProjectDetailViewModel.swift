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

        // MARK: - viewDidLoad

        input.viewDidLoad
            .flatMap { model.find(identifier: modelObject.identifier).resultMap }
            .sink { [weak self] in
                switch $0 {
                case let .success(modelObject):
                    output.modelObject = modelObject.projects
                        .filter { $0.identifier == identifier }
                        .first

                    self?.modelObject = modelObject

                case let .failure(appError):
                    output.appError = appError
                }
            }
            .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 編集ボタンタップ

        input.didTapEditBarButton.sink { [weak self] _ in
            if let modelObject = self?.modelObject {
                routing.showUpdateScreen(
                    identifier: identifier,
                    modelObject: modelObject
                )
            }
        }
        .store(in: &cancellables)

        // MARK: - 削除ボタンタップ

        input.didTapDeleteBarButton.sink { [weak self] _ in
            if let modelObject = self?.modelObject {
                self?.deleteProject(modelObject, identifier: identifier)
                output.isDeleted = true
            }
        }
        .store(in: &cancellables)
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
