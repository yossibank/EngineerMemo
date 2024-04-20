@testable import EngineerMemo
import iOSSnapshotTestCase

final class BasicUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: BasicUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "profile_basic_update"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testBasicUpdateViewController_設定() {
        snapshot(modelObject: nil)
    }

    func testBasicUpdateViewController_更新() {
        snapshot(modelObject: ProfileModelObjectBuilder().build())
    }

    func testBasicUpdateViewController_更新_未設定項目あり() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .name(nil)
                .station(nil)
                .build()
        )
    }
}

private extension BasicUpdateViewControllerSnapshotTest {
    func snapshot(modelObject: ProfileModelObject?) {
        subject = AppControllers.Profile.Basic.Update(modelObject: modelObject)

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
