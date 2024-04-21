@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "MemoUpdate"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testMemoUpdateViewController_作成() {
        snapshot(modelObject: nil)
    }

    func testMemoUpdateViewController_編集() {
        snapshot(modelObject: MemoModelObjectBuilder().build())
    }

    func testMemoUpdateViewController_編集_未入力項目あり() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .content(nil)
                .build()
        )
    }
}

private extension MemoUpdateViewControllerSnapshotTest {
    func snapshot(modelObject: MemoModelObject?) {
        subject = AppControllers.Memo.Update(modelObject: modelObject)
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
