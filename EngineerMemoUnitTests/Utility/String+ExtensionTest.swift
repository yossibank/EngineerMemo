@testable import EngineerMemo
import XCTest

final class StringExtensionTest: XCTestCase {
    func test_phoneText_全て数値の文字列の際にハイフン付き文字列を取得できること() {
        // assert
        XCTAssertEqual(
            "08011112222".phoneText,
            "080-1111-2222"
        )
    }

    func test_phoneText_全て数値以外の文字列の際に未設定の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            "080あいうえお".phoneText,
            "未設定"
        )
    }

    func test_notNoSettingText_未設定の文字列以外の際に文字列を取得できること() {
        // assert
        XCTAssertEqual(
            "abc".notNoSettingText,
            "abc"
        )
    }

    func test_notNoSettingText_未設定の文字列の際にnilを取得できること() {
        // assert
        XCTAssertEqual(
            "未設定".notNoSettingText,
            nil
        )
    }

    func test_repeat_引数回数分の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            "文字列".repeat(10).count,
            30
        )
    }

    func test_empty_空の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            .empty,
            ""
        )
    }

    func test_emptyWord_空文字の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            .emptyWord,
            "空文字"
        )
    }

    func test_nilWord_nilの文字列を取得できること() {
        // assert
        XCTAssertEqual(
            .nilWord,
            "nil"
        )
    }

    func test_noSetting_未設定の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            .noSetting,
            "未設定"
        )
    }

    func test_unknown_不明の文字列を取得できること() {
        // assert
        XCTAssertEqual(
            .unknown,
            "不明"
        )
    }

    func test_randomElement_引数の数値分のランダムな文字列を取得できること() {
        // assert
        XCTAssertEqual(
            String.randomElement(10).count,
            10
        )
    }
}
