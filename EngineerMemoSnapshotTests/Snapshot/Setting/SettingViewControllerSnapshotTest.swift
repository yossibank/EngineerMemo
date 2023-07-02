@testable import EngineerMemo
import iOSSnapshotTestCase

final class SettingViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SettingViewController!

    override func setUp() {
        super.setUp()

        folderName = "設定画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Setting.List()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testSettingViewController_一覧() {
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
