import Combine
import Foundation

final class ProfileUpdateProjectViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title: String?
        @Published var content: String?
    }

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinished = false
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var cancellables = Set<AnyCancellable>()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        modelObject: ProfileModelObject,
        model: ProfileModelInput,
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

        var project = ProjectModelObject(identifier: UUID().uuidString)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 案件名

        let title = binding.$title
            .dropFirst()
            .sink { title in
                project.title = title
            }

        // MARK: - 案件内容

        let content = binding.$content
            .dropFirst()
            .sink { content in
                project.content = content
            }

        // MARK: - 設定・更新ボタンタップ

        input.didTapBarButton.sink { _ in
            model.createProject(
                modelObject,
                project: project
            )

            output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            title,
            content
        ])
    }
}
