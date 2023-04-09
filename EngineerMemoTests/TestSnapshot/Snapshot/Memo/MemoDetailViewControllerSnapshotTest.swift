@testable import EngineerMemo
import iOSSnapshotTestCase
import OHHTTPStubs
import OHHTTPStubsSwift

final class MemoDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoDetailViewController!

    override func setUp() {
        super.setUp()

        folderName = "メモ詳細画面"

        recordMode = SnapshotTest.recordMode
    }

    func testMemoDetailViewController_短文() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title("title")
                .content("content")
                .build()
        )
    }

    func testMemoDetailViewController_標準() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 10))
                .content(String(repeating: "content ", count: 20))
                .build()
        )
    }

    func testMemoDetailViewController_長文() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 30))
                .content(String(repeating: "content ", count: 60))
                .build()
        )
    }
}

extension MemoDetailViewControllerSnapshotTest {
    func snapshot(modelObject: MemoModelObject) {
        subject = AppControllers.Memo.Detail(modelObject: modelObject)
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
