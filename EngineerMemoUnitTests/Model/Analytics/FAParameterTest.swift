@testable import EngineerMemo
import XCTest

final class FAParameterTest: XCTestCase {
    func test_FAParameter_rawValueで適切な値が返却できていること() {
        // assert
        XCTAssertEqual(FAParameter.screenId.rawValue, "スクリーンID")
        XCTAssertEqual(FAParameter.memoTitle.rawValue, "メモタイトル")
    }
}
