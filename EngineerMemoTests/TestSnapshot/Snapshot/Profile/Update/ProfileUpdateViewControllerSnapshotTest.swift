@testable import EngineerMemo
import iOSSnapshotTestCase
import OHHTTPStubs
import OHHTTPStubsSwift

final class ProfileUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール設定画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Profile.Update(type: .setting)
    }

    func testProfileUpdateViewController_設定() {
        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width,
                height: 1200
            )
        )
    }
}
