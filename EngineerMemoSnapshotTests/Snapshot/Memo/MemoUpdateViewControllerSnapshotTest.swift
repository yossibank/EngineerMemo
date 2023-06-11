@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "メモ作成・編集画面"

        recordMode = SnapshotTest.recordMode
    }

    func testMemoUpdateViewController_作成() {
        snapshot(type: .create)
    }

    func testMemoUpdateViewController_編集() {
        snapshot(
            type: .update(
                MemoModelObjectBuilder().build()
            )
        )
    }

    func testMemoUpdateViewController_編集_未入力項目あり() {
        snapshot(
            type: .update(
                MemoModelObjectBuilder()
                    .content(nil)
                    .build()
            )
        )
    }
}

private extension MemoUpdateViewControllerSnapshotTest {
    func snapshot(type: MemoUpdateType) {
        subject = AppControllers.Memo.Update(type: type)
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
