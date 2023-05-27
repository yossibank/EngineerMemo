import Combine

final class MemoListViewModel: ViewModel {
    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapCreateButton = PassthroughSubject<Void, Never>()
        let didChangeSort = PassthroughSubject<MemoListSortType, Never>()
        let didChangeCategory = PassthroughSubject<MemoListCategoryType, Never>()
        let didSelectContent = PassthroughSubject<MemoModelObject, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: ModelObject?
        @Published fileprivate(set) var appError: AppError?
    }

    struct ModelObject {
        let isMemoEmpty: Bool
        let isResultEmpty: Bool
        let outputObjects: [MemoModelObject]
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var originalModelObjects: [MemoModelObject] = []
    private var cancellables: Set<AnyCancellable> = .init()

    private let model: MemoModelInput
    private let routing: MemoListRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        model: MemoModelInput,
        routing: MemoListRoutingInput,
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
            .filter { self.originalModelObjects.isEmpty }
            .sink { _ in
                model.fetch { [weak self] result in
                    switch result {
                    case let .success(modelObjects):
                        self?.originalModelObjects = modelObjects
                        self?.configureModelObjects(
                            sort: .descending,
                            category: .all
                        )

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

        // MARK: - メモ作成ボタンタップ

        input.didTapCreateButton.sink { _ in
            routing.showCreateScreen()
        }
        .store(in: &cancellables)

        // MARK: - メモ並び替え選択

        input.didChangeSort
            .withLatestFrom(input.didChangeCategory) { ($0, $1) }
            .sink { [weak self] sort, category in
                self?.configureModelObjects(
                    sort: sort,
                    category: category
                )
            }
            .store(in: &cancellables)

        // MARK: - メモ絞り込み選択

        input.didChangeCategory
            .withLatestFrom(input.didChangeSort) { ($0, $1) }
            .sink { [weak self] category, sort in
                self?.configureModelObjects(
                    sort: sort,
                    category: category
                )
            }
            .store(in: &cancellables)

        // MARK: - メモコンテンツ選択

        input.didSelectContent.sink { modelObject in
            analytics.sendEvent(
                .didTapMemoList(
                    title: modelObject.title ?? .noSetting
                )
            )

            routing.showDetailScreen(identifier: modelObject.identifier)
        }
        .store(in: &cancellables)
    }
}

// MARK: - private methods

private extension MemoListViewModel {
    func configureModelObjects(
        sort: MemoListSortType,
        category: MemoListCategoryType
    ) {
        var modelObjects = originalModelObjects

        switch sort {
        case .descending:
            modelObjects.sort(by: {
                $0.createdAt > $1.createdAt
            })

        case .ascending:
            modelObjects.sort(by: {
                $0.createdAt < $1.createdAt
            })
        }

        let outputObjects: [MemoModelObject]

        switch category {
        case .all:
            outputObjects = modelObjects

        case .todo:
            outputObjects = modelObjects.filter { $0.category == .todo }

        case .technical:
            outputObjects = modelObjects.filter { $0.category == .technical }

        case .interview:
            outputObjects = modelObjects.filter { $0.category == .interview }

        case .event:
            outputObjects = modelObjects.filter { $0.category == .event }

        case .tax:
            outputObjects = modelObjects.filter { $0.category == .tax }

        case .other:
            outputObjects = modelObjects.filter { $0.category == .other }

        case .none:
            outputObjects = modelObjects.filter { $0.category == nil }
        }

        output.modelObject = .init(
            isMemoEmpty: originalModelObjects.isEmpty,
            isResultEmpty: outputObjects.isEmpty,
            outputObjects: outputObjects
        )
    }
}
