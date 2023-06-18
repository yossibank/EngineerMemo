@testable import EngineerMemo
import XCTest

final class IntExtensionTest: XCTestCase {
    func test_withDescription_不正値の際に未設定の文字列を取得できること() {
        // arrange
        let value = -1

        // assert
        XCTAssertEqual(
            value.withDescription,
            "未設定"
        )
    }

    func test_withDescription_有効値の際に数値の文字列を取得できること() {
        // arrange
        let value = 10

        // assert
        XCTAssertEqual(
            value.withDescription,
            "10"
        )
    }

    func test_boolValue_0の際にtureを取得できること() {
        // assert
        XCTAssertTrue(0.boolValue)
    }

    func test_boolValue_0以外の際にfalseを取得できること() {
        // assert
        XCTAssertFalse(1.boolValue)
        XCTAssertFalse(11.boolValue)
        XCTAssertFalse(111.boolValue)
    }

    func test_optionalBoolValue_0の際にtureを取得できること() {
        // assert
        XCTAssertTrue(0.optionalBoolValue!)
    }

    func test_optionalBoolValue_1の際にfalseを取得できること() {
        // assert
        XCTAssertFalse(1.optionalBoolValue!)
    }

    func test_optionalBoolValue_0_1以外の際にnilを取得できること() {
        // assert
        XCTAssertNil(2.optionalBoolValue)
        XCTAssertNil(3.optionalBoolValue)
        XCTAssertNil(4.optionalBoolValue)
    }

    func test_invalid_マイナス1の数値を取得できること() {
        // arrange
        let value = -1

        // assert
        XCTAssertEqual(
            value,
            .invalid
        )
    }

    func test_nilIndex_2の数値を取得できること() {
        // arrange
        let value = 2

        // assert
        XCTAssertEqual(
            value,
            .nilIndex
        )
    }
}
