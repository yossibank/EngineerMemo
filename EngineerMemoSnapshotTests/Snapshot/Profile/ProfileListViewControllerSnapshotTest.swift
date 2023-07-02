import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileListViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "プロフィール画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Profile.List()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testProfileListViewController_未設定() {
        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testProfileListViewController_基本情報設定() {
        dataInsert(modelObject: ProfileModelObjectBuilder().build())

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIWindow.windowFrame.width,
                height: 1200
            ),
            viewAfter: 0.5
        )
    }

    func testProfileListViewController_基本情報_経験スキル設定() {
        dataInsert(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIWindow.windowFrame.width,
                height: 1300
            ),
            viewAfter: 0.5
        )
    }

    func testProfileListViewController_基本情報_経験スキル_案件経歴設定() {
        dataInsert(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .projects([
                    ProjectModelObjectBuilder().identifier("identifier1").build(),
                    ProjectModelObjectBuilder().identifier("identifier2").build()
                ])
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIWindow.windowFrame.width,
                height: 1700
            ),
            viewAfter: 0.5
        )
    }
}

private extension ProfileListViewControllerSnapshotTest {
    func dataInsert(modelObject: ProfileModelObject) {
        CoreDataStorage<Profile>().create().sink {
            modelObject.insertBasic($0, isNew: true)

            if !modelObject.skill.isNil {
                modelObject.insertSkill($0)
            }

            if !modelObject.projects.isEmpty {
                modelObject.insertProject($0)
            }
        }
        .store(in: &cancellables)
    }
}
