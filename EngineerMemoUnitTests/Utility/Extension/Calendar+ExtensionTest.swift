@testable import EngineerMemo
import XCTest

final class CalendarExtensionTest: XCTestCase {
    func test_date_年月日のDate型を取得できること() {
        // arrange
        let calendar = Calendar.current
        let date = Calendar.date(
            year: 2000,
            month: 1,
            day: 1
        )!

        // act
        let components = calendar.dateComponents(
            [.year, .month, .day],
            from: date
        )

        // assert
        XCTAssertEqual(
            components.year,
            2000
        )

        XCTAssertEqual(
            components.month,
            1
        )

        XCTAssertEqual(
            components.day,
            1
        )
    }
}
