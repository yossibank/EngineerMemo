import Combine
import Foundation

final class MemoUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var category: MemoInputCategoryType = .noSetting
        @Published var title = ""
        @Published var content = ""
    }

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinished = false
        @Published fileprivate(set) var isEnabled = false
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var modelObject = MemoModelObject(
        createdAt: .init(),
        identifier: UUID().uuidString
    )

    private var cancellables = Set<AnyCancellable>()

    private let model: MemoModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: MemoModelInput,
        modelObject: MemoModelObject?,
        analytics: FirebaseAnalyzable
    ) {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { [weak self] _ in
            if let modelObject {
                self?.modelObject = modelObject
                self?.binding.title = modelObject.title ?? .empty
                self?.binding.content = modelObject.content ?? .empty
            }
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - カテゴリー

        let category = binding.$category.sink { [weak self] in
            self?.modelObject.category = $0.category
        }

        // MARK: - タイトル

        let title = binding.$title.sink { [weak self] in
            self?.modelObject.title = $0
        }

        // MARK: - コンテンツ

        let content = binding.$content.sink { [weak self] in
            self?.modelObject.content = $0
        }

        // MARK: - 作成ボタン有効化

        Publishers.CombineLatest(
            binding.$title,
            binding.$content
        )
        .map { !$0.0.isEmpty && !$0.1.isEmpty }
        .sink { isEnabled in
            output.isEnabled = isEnabled
        }
        .store(in: &cancellables)

        // MARK: - 作成ボタンタップ

        input.didTapBarButton.sink { [weak self] _ in
            guard let self else {
                return
            }

            if modelObject.isNil {
                createMemo()
            } else {
                updateMemo()
            }

            output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            category,
            title,
            content
        ])
    }
}

// MARK: - private methods

private extension MemoUpdateViewModel {
    func createMemo() {
        model.create(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }

    func updateMemo() {
        model.update(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
