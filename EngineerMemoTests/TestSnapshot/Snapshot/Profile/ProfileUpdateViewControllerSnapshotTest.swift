@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileUpdateBasicViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    func testProfileUpdateViewController_設定() {
        snapshot()
    }

    func testProfileUpdateViewController_更新() {
        snapshot(modelObject: ProfileModelObjectBuilder().build())
    }

    func testProfileUpdateViewController_更新_未設定項目あり() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .name(nil)
                .station(nil)
                .build()
        )
    }
}

private extension ProfileUpdateViewControllerSnapshotTest {
    func snapshot(modelObject: ProfileModelObject? = nil) {
        subject = AppControllers.Profile.Update.Basic(modelObject: modelObject)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width,
                height: 1100
            )
        )
    }
}
