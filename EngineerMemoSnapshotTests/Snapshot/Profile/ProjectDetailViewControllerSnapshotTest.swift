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
                        .role("プログラマー1")
                        .content("テストプロジェクト内容1")
                        .startDate(Calendar.date(year: 2020, month: 4, day: 1))
                        .endDate(Calendar.date(year: 2021, month: 6, day: 1))
                        .build()
                ])
                .build()
        )
    }

    func testProjectDetailViewController_詳細_開始期間未設定() {
        snapshot(
            identifier: "identifier:テストプロジェクトタイトル2",
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .title("テストプロジェクトタイトル2")
                        .role("プログラマー2")
                        .content("テストプロジェクト内容2")
                        .startDate(nil)
                        .endDate(Calendar.date(year: 2021, month: 6, day: 1))
                        .build()
                ])
                .build()
        )
    }

    func testProjectDetailViewController_詳細_終了期間未設定() {
        snapshot(
            identifier: "identifier:テストプロジェクトタイトル3",
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .title("テストプロジェクトタイトル3")
                        .role("プログラマー3")
                        .content("テストプロジェクト内容3")
                        .startDate(Calendar.date(year: 2020, month: 4, day: 1))
                        .endDate(nil)
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
                project.role = object.role
                project.content = object.content
                project.startDate = object.startDate
                project.endDate = object.endDate
                project.identifier = "identifier:\(project.title!)"
                return project
            }

            profileObject.addToProjects(.init(array: projects))

            context.saveIfNeeded()
        }
        .store(in: &cancellables)

        subject = AppControllers.Profile.Project.Detail(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.5
        )
    }
}
