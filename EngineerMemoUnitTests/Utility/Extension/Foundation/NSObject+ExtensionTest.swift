@testable import EngineerMemo
import XCTest

final class NSObjectExtensionTest: XCTestCase {
    func test_className_static_クラス名がStringで取得できること() {
        // arrange
        class Test: NSObject {}

        let expected = "Test"

        // act
        let value = Test.className

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }

    func test_className_クラス名がStringで取得できること() {
        // arrange
        class Test: NSObject {}

        let expected = "Test"

        // act
        let value = Test().className

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
