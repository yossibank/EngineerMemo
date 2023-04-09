import Combine
import Foundation

final class MemoUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title = ""
        @Published var content = ""
    }

    final class Input: InputObject {
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

    private var modelObject = MemoModelObject(identifier: UUID().uuidString)
    private var cancellables: Set<AnyCancellable> = .init()

    private let model: MemoModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: MemoModelInput,
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

        // MARK: - viewWillAppear

        input.viewWillAppear
            .sink { _ in
                analytics.sendEvent(.screenView)
            }
            .store(in: &cancellables)

        // MARK: - タイトル

        let title = binding.$title.sink { [weak self] title in
            self?.modelObject.title = title
        }

        // MARK: - コンテンツ

        let content = binding.$content.sink { content in
            self.modelObject.content = content
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

            self.model.create(modelObject: self.modelObject)
            self.output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            title,
            content
        ])
    }
}
