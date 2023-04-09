import Combine
import Foundation

final class MemoCreateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title = ""
        @Published var content = ""
    }

    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapCreateButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinished = false
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

        // MARK: - 作成ボタンタップ

        input.didTapCreateButton.sink { [weak self] _ in
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
