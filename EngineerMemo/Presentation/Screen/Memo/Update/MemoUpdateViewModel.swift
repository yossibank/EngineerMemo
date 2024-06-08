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

        cancellables.formUnion([
            // MARK: - viewDidLoad

            input.viewDidLoad.weakSink(with: self) {
                if let modelObject {
                    $0.modelObject = modelObject
                    $0.binding.title = modelObject.title ?? .empty
                    $0.binding.content = modelObject.content ?? .empty
                }
            },

            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - カテゴリー

            binding.$category.weakSink(with: self) {
                $0.modelObject.category = $1.category
            },

            // MARK: - タイトル

            binding.$title.weakSink(with: self) {
                $0.modelObject.title = $1
            },

            // MARK: - コンテンツ

            binding.$content.weakSink(with: self) {
                $0.modelObject.content = $1
            },

            // MARK: - 作成ボタン有効化

            Publishers.CombineLatest(
                binding.$title,
                binding.$content
            )
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .sink { isEnabled in
                output.isEnabled = isEnabled
            },

            // MARK: - 作成ボタンタップ

            input.didTapBarButton.weakSink(with: self) {
                if modelObject.isNil {
                    $0.createMemo()
                } else {
                    $0.updateMemo()
                }

                output.isFinished = true
            }
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
