@testable import EngineerMemo
import XCTest

final class IntExtensionTest: XCTestCase {
    func test_withDescription_不正値の際に未設定の文字列を取得できること() {
        // arrange
        let int = -1

        // act
        let value = int.withDescription

        // assert
        XCTAssertEqual(
            value,
            "未設定"
        )
    }

    func test_withDescription_有効値の際に数値の文字列を取得できること() {
        // arrange
        let int = 10

        // act
        let value = int.withDescription

        // assert
        XCTAssertEqual(
            value,
            "10"
        )
    }

    func test_boolValue_0の際にtureを取得できること() {
        // arrange
        let int = 0

        // act
        let value = int.boolValue

        // assert
        XCTAssertTrue(value)
    }

    func test_boolValue_0以外の際にfalseを取得できること() {
        // arrange
        let int1 = 1
        let int2 = 11
        let int3 = 111

        // act
        let value1 = int1.boolValue
        let value2 = int2.boolValue
        let value3 = int3.boolValue

        // assert
        XCTAssertFalse(value1)
        XCTAssertFalse(value2)
        XCTAssertFalse(value3)
    }

    func test_optionalBoolValue_0の際にtureを取得できること() {
        // arrange
        let int = 0

        // act
        let value = int.optionalBoolValue!

        // assert
        XCTAssertTrue(value)
    }

    func test_optionalBoolValue_1の際にfalseを取得できること() {
        // arrange
        let int = 1

        // act
        let value = int.optionalBoolValue!

        // assert
        XCTAssertFalse(value)
    }

    func test_optionalBoolValue_0_1以外の際にnilを取得できること() {
        // arrange
        let int1 = 2
        let int2 = 3
        let int3 = 4

        // act
        let value1 = int1.optionalBoolValue
        let value2 = int2.optionalBoolValue
        let value3 = int3.optionalBoolValue

        // assert
        XCTAssertNil(value1)
        XCTAssertNil(value2)
        XCTAssertNil(value3)
    }

    func test_invalid_マイナス1の数値を取得できること() {
        // arrange
        let expected = -1

        // act
        let value = Int.invalid

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
