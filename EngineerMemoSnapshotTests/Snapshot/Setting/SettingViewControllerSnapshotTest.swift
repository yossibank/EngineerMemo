@testable import EngineerMemo
import iOSSnapshotTestCase

final class SettingViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SettingViewController!

    override func setUp() {
        super.setUp()

        folderName = "Setting"

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
