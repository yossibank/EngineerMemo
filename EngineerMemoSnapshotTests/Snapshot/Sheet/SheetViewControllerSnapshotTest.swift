@testable import EngineerMemo
import iOSSnapshotTestCase

final class SheetViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SheetViewController!

    override func setUp() {
        super.setUp()

        folderName = "Sheet"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testSheetViewController_全項目存在() {
        snapshot(
            .init(
                title: "タイトル",
                message: "メッセージ",
                actions: [
                    .init(title: "デフォルト", actionType: .default, action: {}),
                    .init(title: "警告", actionType: .warning, action: {}),
                    .init(title: "アラート", actionType: .alert, action: {}),
                    .init(title: "閉じる", actionType: .close, action: {})
                ]
            )
        )
    }

    func testSheetViewController_全項目存在_長文() {
        snapshot(
            .init(
                title: "タイトル ".repeat(20),
                message: "メッセージ ".repeat(20),
                actions: [
                    .init(title: "デフォルト", actionType: .default, action: {}),
                    .init(title: "警告", actionType: .warning, action: {}),
                    .init(title: "アラート", actionType: .alert, action: {}),
                    .init(title: "閉じる", actionType: .close, action: {})
                ]
            )
        )
    }
}

private extension SheetViewControllerSnapshotTest {
    func snapshot(_ sheetContent: SheetContent) {
        subject = AppControllers.Sheet(sheetContent)
        snapshotVerifyView(viewMode: .normal(subject))
    }
}
