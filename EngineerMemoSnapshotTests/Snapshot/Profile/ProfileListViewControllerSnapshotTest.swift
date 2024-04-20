import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileListViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "profile_list"

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

    func testProfileListViewController_基本情報_案件経歴_案件開始日新しい順設定() {
        DataHolder.profileProjectSortType = .descending

        dataInsert(
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .identifier("identifier1")
                        .title("案件1")
                        .content("案件1のプロジェクト")
                        .startDate(Calendar.date(year: 2021, month: 7, day: 1))
                        .endDate(Calendar.date(year: 2022, month: 3, day: 30))
                        .build(),
                    ProjectModelObjectBuilder()
                        .identifier("identifier2")
                        .title("案件2")
                        .content("案件2のプロジェクト")
                        .startDate(Calendar.date(year: 2022, month: 4, day: 2))
                        .endDate(nil)
                        .build()
                ])
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIWindow.windowFrame.width,
                height: 1500
            ),
            viewAfter: 0.5
        )
    }

    func testProfileListViewController_基本情報_案件経歴_案件開始日古い順設定() {
        DataHolder.profileProjectSortType = .ascending

        dataInsert(
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .identifier("identifier1")
                        .title("案件1")
                        .content("案件1のプロジェクト")
                        .startDate(Calendar.date(year: 2021, month: 7, day: 1))
                        .endDate(Calendar.date(year: 2022, month: 3, day: 30))
                        .build(),
                    ProjectModelObjectBuilder()
                        .identifier("identifier2")
                        .title("案件2")
                        .content("案件2のプロジェクト")
                        .startDate(Calendar.date(year: 2022, month: 4, day: 2))
                        .endDate(nil)
                        .build()
                ])
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIWindow.windowFrame.width,
                height: 1500
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
