import Combine
import Foundation

final class ProjectUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title: String?
        @Published var startDate: Date?
        @Published var endDate: Date?
        @Published var role: String?
        @Published var processes: [ProjectModelObject.Process] = []
        @Published var language: String?
        @Published var database: String?
        @Published var serverOS: String?
        @Published var tools: [String] = []
        @Published var content: String?
    }

    final class Input: InputObject {
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
        identifier: String,
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

        var updatedObject = modelObject.projects.filter {
            $0.identifier == identifier
        }.first ?? ProjectModelObject(identifier: identifier)

        cancellables.formUnion([
            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - 案件名

            binding.$title
                .dropFirst()
                .sink { updatedObject.title = $0 },

            // MARK: - 開始日

            binding.$startDate
                .dropFirst()
                .sink { updatedObject.startDate = $0 },

            // MARK: - 終了日

            binding.$endDate
                .dropFirst()
                .sink { updatedObject.endDate = $0 },

            // MARK: - 役割

            binding.$role
                .dropFirst()
                .sink { updatedObject.role = $0 },

            // MARK: - 担当案件

            binding.$processes
                .dropFirst()
                .sink { updatedObject.processes = $0 },

            // MARK: - 使用言語

            binding.$language
                .dropFirst()
                .sink { updatedObject.language = $0 },

            // MARK: - データベース

            binding.$database
                .dropFirst()
                .sink { updatedObject.database = $0 },

            // MARK: - サーバOS

            binding.$serverOS
                .dropFirst()
                .sink { updatedObject.serverOS = $0 },

            // MARK: - FW・MV・ツール等

            binding.$tools
                .dropFirst()
                .sink { updatedObject.tools = $0 },

            // MARK: - 内容

            binding.$content
                .dropFirst()
                .sink { updatedObject.content = $0 },

            // MARK: - 設定・更新ボタンタップ

            input.didTapBarButton.weakSink(with: self) {
                if modelObject.projects.filter({ $0.identifier == identifier }).first.isNil {
                    var modelObject = modelObject
                    modelObject.projects = [updatedObject]
                    $0.createProject(modelObject)
                } else {
                    var modelObject = modelObject
                    modelObject.projects = [updatedObject]
                    $0.updateProject(modelObject, identifier: identifier)
                }

                $0.output.isFinished = true
            }
        ])
    }
}

// MARK: - private methods

private extension ProjectUpdateViewModel {
    func createProject(_ modelObject: ProfileModelObject) {
        model.createProject(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }

    func updateProject(
        _ modelObject: ProfileModelObject,
        identifier: String
    ) {
        model.updateProject(modelObject, identifier: identifier)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
