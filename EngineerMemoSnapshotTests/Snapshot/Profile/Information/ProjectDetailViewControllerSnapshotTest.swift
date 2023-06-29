import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProjectDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProjectDetailViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "プロフィール案件詳細画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testProjectDetailViewController_詳細() {
        snapshot(
            identifier: "identifier:テストプロジェクトタイトル1",
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .title("テストプロジェクトタイトル1")
                        .content("テストプロジェクト内容1")
                        .build()
                ])
                .build()
        )
    }
}

private extension ProjectDetailViewControllerSnapshotTest {
    func snapshot(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        CoreDataStorage<Profile>().create().sink {
            let context = $0.context
            let profileObject = $0.object

            profileObject.identifier = "identifier"

            let projects = modelObject.projects.map { object -> Project in
                let project = Project(context: context)
                project.title = object.title
                project.content = object.content
                project.identifier = "identifier:\(project.title!)"
                return project
            }

            profileObject.addToProjects(.init(array: projects))

            context.saveIfNeeded()
        }
        .store(in: &cancellables)

        subject = AppControllers.Profile.Information.Project.Detail(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.5
        )
    }
}
