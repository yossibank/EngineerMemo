@testable import EngineerMemo
import XCTest

final class BoolExtensionTest: XCTestCase {
    func test_boolValue_trueの際に0の数値を取得できること() {
        // arrange
        let bool = true

        // act
        let value = bool.boolValue

        // assert
        XCTAssertEqual(
            value,
            0
        )
    }

    func test_boolValue_falseの際に1の数値を取得できること() {
        // arrange
        let bool = false

        // act
        let value = bool.boolValue

        // assert
        XCTAssertEqual(
            value,
            1
        )
    }
}
