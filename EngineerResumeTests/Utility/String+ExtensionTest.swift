@testable import EngineerResume
import XCTest

final class StringExtensionTest: XCTestCase {
    func test_noSetting_未設定の文字列を取得できること() {
        XCTAssertEqual(.noSetting, "未設定")
    }
}
