@testable import EngineerMemo
import XCTest

final class LocaleExtensionTest: XCTestCase {
    func test_japan_日本のidentifierのLocaleを生成できること() {
        // assert
        XCTAssertEqual(
            Locale.japan,
            .init(identifier: "ja_JP")
        )
    }
}
