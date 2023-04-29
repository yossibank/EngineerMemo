import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileDetailViewController!
    private var cancellables: Set<AnyCancellable> = .init()

    override func setUp() {
        super.setUp()

        folderName = "フォルダ名"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Profile.Detail()
    }

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testProfileDetailViewController_未設定() {
        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testProfileDetailViewController_基本情報設定() {
        dataInsert(ProfileModelObjectBuilder().build())

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 1000
            ),
            viewAfter: 0.3
        )
    }

    func testProfileDetailViewController_基本情報_経験スキル設定() {
        dataInsert(
            ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 1000
            ),
            viewAfter: 0.3
        )
    }
}

private extension ProfileDetailViewControllerSnapshotTest {
    func dataInsert(_ modelObject: ProfileModelObject) {
        CoreDataStorage<Profile>().create().sink { profile in
            modelObject.basicInsert(
                profile,
                isNew: true
            )

            if let skillModelObject = modelObject.skill {
                CoreDataStorage<Skill>().create().sink { skill in
                    skillModelObject.skillInsert(skill)
                    profile.skill = skill
                }
                .store(in: &self.cancellables)
            }
        }
        .store(in: &cancellables)
    }
}
