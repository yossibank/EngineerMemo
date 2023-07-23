@testable import EngineerMemo
import XCTest

final class LocaleExtensionTest: XCTestCase {
    func test_japan_日本のidentifierのLocaleを生成できること() {
        // arrange
        let expected = Locale(identifier: "ja_JP")

        // act
        let value = Locale.japan

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
