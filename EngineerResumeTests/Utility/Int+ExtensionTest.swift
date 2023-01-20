@testable import EngineerResume
import XCTest

final class IntExtensionTest: XCTestCase {
    func test_withDescription_不正値の際に未設定の文字列を取得できること() {
        // arrange
        let value = -1

        // assert
        XCTAssertEqual(value.withDescription, "未設定")
    }

    func test_withDescription_有効値の際に数値の文字列を取得できること() {
        // arrange
        let value = 10

        // assert
        XCTAssertEqual(value.withDescription, "10")
    }

    func test_invalid_マイナス1の数値を取得できること() {
        // arrange
        let value = -1

        XCTAssertEqual(value, .invalid)
    }
}
