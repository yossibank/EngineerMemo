import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileListViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "ProfileList"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Profile.List()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        cancellables.removeAll()

        resetUserDefaults()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testProfileListViewController_未設定() {
        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 1.0
        )
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
            viewAfter: 1.0
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
            viewAfter: 1.0
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
