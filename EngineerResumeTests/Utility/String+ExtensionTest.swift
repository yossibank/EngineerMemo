@testable import EngineerResume
import XCTest

final class StringExtensionTest: XCTestCase {
    func test_phoneText_全て数値の文字列の際にハイフン付き文字列を取得できること() {
        XCTAssertEqual("08011112222".phoneText, "080-1111-2222")
    }

    func test_phoneText_全て数値以外の文字列の際にnilを取得できること() {
        XCTAssertEqual("080あいうえお".phoneText, nil)
    }

    func test_noSetting_未設定の文字列を取得できること() {
        XCTAssertEqual(.noSetting, "未設定")
    }

    func test_unknown_不明の文字列を取得できること() {
        XCTAssertEqual(.unknown, "不明")
    }

    func test_randomElement_引数の数値分のランダムな文字列を取得できること() {
        XCTAssertEqual(String.randomElement(10).count, 10)
    }
}
