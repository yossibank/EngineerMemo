@testable import EngineerMemo
import iOSSnapshotTestCase
import OHHTTPStubs
import OHHTTPStubsSwift

final class ProfileIconViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileIconViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィールアイコン変更画面"

        recordMode = SnapshotTest.recordMode

        DataHolder.profileIcon = .penguin

        subject = AppControllers.Profile.Icon(
            modelObject: ProfileModelObjectBuilder().build()
        )
    }

    override func tearDown() {
        super.tearDown()

        resetUserDefaults()
    }

    func testProfileIconViewController_全項目() {
        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width,
                height: 1000
            )
        )
    }
}
