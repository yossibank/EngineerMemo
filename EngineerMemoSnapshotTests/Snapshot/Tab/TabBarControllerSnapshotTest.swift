@testable import EngineerMemo
import iOSSnapshotTestCase

final class TabBarControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: TabBarController!

    override func setUp() {
        super.setUp()

        folderName = "tab"

        recordMode = SnapshotTest.recordMode

        subject = .init()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testTabBarController_プロフィールタブ() {
        snapshot(.profile)
    }

    func testTabBarController_メモタブ() {
        snapshot(.memo)
    }

    func testTabBarController_設定タブ() {
        snapshot(.setting)
    }
}

private extension TabBarControllerSnapshotTest {
    func snapshot(_ tabItem: TabItem) {
        subject.setViewControllers(
            TabItem.allCases.map(\.rootViewController),
            animated: false
        )

        subject.selectedIndex = tabItem.rawValue

        snapshotVerifyView(
            viewMode: .normal(subject),
            viewAfter: 1.0
        )
    }
}
