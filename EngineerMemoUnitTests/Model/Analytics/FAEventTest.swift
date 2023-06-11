@testable import EngineerMemo
import XCTest

final class FAEventTest: XCTestCase {
    func test_FAEvent_nameの値が返却できていること() {
        XCTAssertEqual(
            FAEvent.screenView.name,
            "画面表示"
        )

        XCTAssertEqual(
            FAEvent.didTapMemoList(title: "title").name,
            "メモ一覧タップ"
        )
    }

    func test_FAEvent_parameterの値が返却できてること() {
        XCTAssertTrue(
            FAEvent.screenView.parameter.isEmpty
        )

        XCTAssertEqual(
            FAEvent.didTapMemoList(title: "title").parameter["メモタイトル"] as! String,
            "title"
        )
    }
}
