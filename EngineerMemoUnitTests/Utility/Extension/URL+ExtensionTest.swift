@testable import EngineerMemo
import XCTest

final class URLExtensionTest: XCTestCase {
    func test_queryValue_identifierのquery値を取得できること() {
        // arrange
        let url = URL(string: "https://example.com?identifier=test123")!

        // act
        let value = url.queryValue(byName: .identifier)

        // assert
        XCTAssertEqual(
            value,
            "test123"
        )
    }
}
