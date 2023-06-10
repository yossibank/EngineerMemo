@testable import EngineerMemo
import XCTest

final class TimeZoneExtensionTest: XCTestCase {
    func test_tokyo_アジア東京のidentifierのTimeZoneを生成できること() {
        // assert
        XCTAssertEqual(
            TimeZone.tokyo,
            .init(identifier: "Asia/Tokyo")
        )
    }
}
