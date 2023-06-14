@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileUpdateBasicViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileUpdateBasicViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール基本情報設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testProfileUpdateBasicViewController_設定() {
        snapshot()
    }

    func testProfileUpdateBasicViewController_更新() {
        snapshot(modelObject: ProfileModelObjectBuilder().build())
    }

    func testProfileUpdateBasicViewController_更新_未設定項目あり() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .name(nil)
                .station(nil)
                .build()
        )
    }
}

private extension ProfileUpdateBasicViewControllerSnapshotTest {
    func snapshot(modelObject: ProfileModelObject? = nil) {
        subject = AppControllers.Profile.Update.Basic(modelObject: modelObject)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIWindow.windowFrame.width,
                height: 1100
            )
        )
    }
}
