@testable import EngineerMemo
import XCTest

final class StringExtensionTest: XCTestCase {
    func test_phoneText_全て数値の文字列の際にハイフン付き文字列を取得できること() {
        // arrange
        let expected = "080-1111-2222"

        // act
        let value = "08011112222".phoneText

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_phoneText_全て数値以外の文字列の際に未設定の文字列を取得できること() {
        // arrange
        let expected = "未設定"

        // act
        let value = "080あいうえお".phoneText

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_notNoSettingText_未設定の文字列以外の際に文字列を取得できること() {
        // arrange
        let expected = "abc"

        // act
        let value = "abc".notNoSettingText

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_notNoSettingText_未設定の文字列の際にnilを取得できること() {
        // arrange
        let expected: String? = nil

        // act
        let value = "未設定".notNoSettingText

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_repeat_引数回数分の文字列を取得できること() {
        // arrange
        let expected = 30

        // act
        let value = "文字列".repeat(10).count

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_empty_空の文字列を取得できること() {
        // arrange
        let expected = ""

        // act
        let value = String.empty

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_emptyWord_空文字の文字列を取得できること() {
        // arrange
        let expected = "空文字"

        // act
        let value = String.emptyWord

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_nilWord_nilの文字列を取得できること() {
        // arrange
        let expected = "nil"

        // act
        let value = String.nilWord

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_noSetting_未設定の文字列を取得できること() {
        // arrange
        let expected = "未設定"

        // act
        let value = String.noSetting

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_unknown_不明の文字列を取得できること() {
        // arrange
        let expected = "不明"

        // act
        let value = String.unknown

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_randomElement_引数の数値分のランダムな文字列を取得できること() {
        // arrange
        let expected = 10

        // act
        let value = String.randomElement(10).count

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
