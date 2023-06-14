import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileDetailViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "プロフィール詳細画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Profile.Detail()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
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
                width: UIWindow.windowFrame.width,
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
                width: UIWindow.windowFrame.width,
                height: 1100
            ),
            viewAfter: 0.3
        )
    }
}

private extension ProfileDetailViewControllerSnapshotTest {
    func dataInsert(_ modelObject: ProfileModelObject) {
        CoreDataStorage<Profile>().create().sink { coreData in
            modelObject.basicInsert(
                coreData.object,
                isNew: true
            )

            if let skillModelObject = modelObject.skill {
                CoreDataStorage<Skill>().create().sink {
                    skillModelObject.skillInsert(
                        $0.object,
                        isNew: true
                    )

                    coreData.object.skill = $0.object
                }
                .store(in: &self.cancellables)
            }

            coreData.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
