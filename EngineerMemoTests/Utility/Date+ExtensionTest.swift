@testable import EngineerMemo
import XCTest

final class DateExtensionTest: XCTestCase {
    func test_toString_年月日の文字列を取得できること() {
        // arrange
        let date = Calendar.date(year: 2000, month: 1, day: 1)

        // act
        let dateString = date!.toString

        // assert
        XCTAssertEqual(dateString, "2000年1月1日")
    }
}
