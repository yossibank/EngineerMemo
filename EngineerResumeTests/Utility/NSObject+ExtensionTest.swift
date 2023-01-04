@testable import EngineerResume
import XCTest

final class NSObjectExtensionTest: XCTestCase {
    func test_className_クラス名がStringで取得できること() {
        XCTAssertEqual(NSObjectExtensionTest.className, "NSObjectExtensionTest")
    }
}
