@testable import EngineerMemo
import iOSSnapshotTestCase

final class TabBarControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: TabBarController!

    override func setUp() {
        super.setUp()

        folderName = "タブ"

        recordMode = SnapshotTest.recordMode

        subject = .init()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testTabBarController_プロフィールタブ() {
        subject.selectedIndex = TabItem.profile.rawValue
        snapshotVerifyView(viewMode: .normal(subject))
    }

    func testTabBarController_メモタブ() {
        subject.selectedIndex = TabItem.memo.rawValue
        snapshotVerifyView(viewMode: .normal(subject))
    }
}
