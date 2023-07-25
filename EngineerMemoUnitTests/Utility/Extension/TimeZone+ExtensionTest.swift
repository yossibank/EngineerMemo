@testable import EngineerMemo
import XCTest

final class TimeZoneExtensionTest: XCTestCase {
    func test_tokyo_アジア東京のidentifierのTimeZoneを生成できること() {
        // arrange
        let expected = TimeZone(identifier: "Asia/Tokyo")

        // act
        let value = TimeZone.tokyo

        // assert
        XCTAssertEqual(
            value,
            expected
        )
    }
}
