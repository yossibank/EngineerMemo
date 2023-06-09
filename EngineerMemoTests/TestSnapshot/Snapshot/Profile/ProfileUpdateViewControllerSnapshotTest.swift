@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileBasicUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    func testProfileUpdateViewController_設定() {
        snapshot(type: .setting)
    }

    func testProfileUpdateViewController_更新() {
        snapshot(
            type: .update(
                ProfileModelObjectBuilder().build()
            )
        )
    }

    func testProfileUpdateViewController_更新_未設定項目あり() {
        snapshot(
            type: .update(
                ProfileModelObjectBuilder()
                    .name(nil)
                    .station(nil)
                    .build()
            )
        )
    }
}

private extension ProfileUpdateViewControllerSnapshotTest {
    func snapshot(type: ProfileUpdateType) {
        subject = AppControllers.Profile.Update(type: type)

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
