@testable import EngineerMemo
import XCTest

final class BoolExtensionTest: XCTestCase {
    func test_boolValue_trueの際に0の数値を取得できること() {
        XCTAssertEqual(
            true.boolValue,
            0
        )
    }

    func test_boolValue_falseの際に1の数値を取得できること() {
        XCTAssertEqual(
            false.boolValue,
            1
        )
    }
}
