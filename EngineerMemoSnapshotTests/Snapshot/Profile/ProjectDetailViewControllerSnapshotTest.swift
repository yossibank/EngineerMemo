import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProjectDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProjectDetailViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "profile_project_detail"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testProjectDetailViewController_詳細() {
        let modelObject = ProfileModelObjectBuilder()
            .projects([
                ProjectModelObjectBuilder()
                    .title("テストプロジェクトタイトル1")
                    .role("プログラマー1")
                    .processes([.implementation, .systemTesting, .intergrationTesting])
                    .language("Swift")
                    .database("CoreData")
                    .serverOS("Ubuntu")
                    .tools(["Firebase", "MagicPod"])
                    .content("テストプロジェクト内容1")
                    .startDate(Calendar.date(year: 2020, month: 4, day: 1))
                    .endDate(Calendar.date(year: 2021, month: 6, day: 1))
                    .build()
            ])
            .build()

        dataInsert(modelObject: modelObject)

        snapshot(
            identifier: "identifier:テストプロジェクトタイトル1",
            modelObject: modelObject
        )
    }

    func testProjectDetailViewController_詳細_開始期間未設定() {
        let modelObject = ProfileModelObjectBuilder()
            .projects([
                ProjectModelObjectBuilder()
                    .title("テストプロジェクトタイトル2")
                    .role("プログラマー2")
                    .processes([.requirementDefinition, .functionalDesign])
                    .language(nil)
                    .database(nil)
                    .serverOS(nil)
                    .tools([])
                    .content("テストプロジェクト内容2")
                    .startDate(nil)
                    .endDate(Calendar.date(year: 2021, month: 6, day: 1))
                    .build()
            ])
            .build()

        dataInsert(modelObject: modelObject)

        snapshot(
            identifier: "identifier:テストプロジェクトタイトル2",
            modelObject: modelObject
        )
    }

    func testProjectDetailViewController_詳細_終了期間未設定() {
        let modelObject = ProfileModelObjectBuilder()
            .projects([
                ProjectModelObjectBuilder()
                    .title("テストプロジェクトタイトル3")
                    .role("プログラマー3")
                    .processes([.requirementDefinition, .maintenance])
                    .language(nil)
                    .database(nil)
                    .serverOS(nil)
                    .tools([])
                    .content("テストプロジェクト内容3")
                    .startDate(Calendar.date(year: 2020, month: 4, day: 1))
                    .endDate(nil)
                    .build()
            ])
            .build()

        dataInsert(modelObject: modelObject)

        snapshot(
            identifier: "identifier:テストプロジェクトタイトル3",
            modelObject: modelObject
        )
    }
}

private extension ProjectDetailViewControllerSnapshotTest {
    func dataInsert(modelObject: ProfileModelObject) {
        CoreDataStorage<Profile>().create().sink {
            let context = $0.context
            let profileObject = $0.object

            profileObject.identifier = "identifier"

            let projects = modelObject.projects.map { object -> Project in
                let project = Project(context: context)
                project.title = object.title
                project.role = object.role
                project.processes = object.processes.map(\.rawValue)
                project.language = object.language
                project.database = object.database
                project.serverOS = object.serverOS
                project.tools = object.tools
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
    }

    func snapshot(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        subject = AppControllers.Profile.Project.Detail(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIWindow.windowFrame.width,
                height: 1300
            ),
            viewAfter: 1.0
        )
    }
}
