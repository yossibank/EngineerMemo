@testable import EngineerMemo
import iOSSnapshotTestCase

final class TabBarControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: TabBarController!

    override func setUp() {
        super.setUp()

        folderName = "フォルダ名"

        recordMode = SnapshotTest.recordMode

        subject = .init()
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
