@testable import EngineerMemo
import XCTest

final class NSObjectExtensionTest: XCTestCase {
    func test_className_クラス名がStringで取得できること() {
        // arrange
        let expected = "NSObjectExtensionTest"

        // act
        let value = NSObjectExtensionTest.className

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
