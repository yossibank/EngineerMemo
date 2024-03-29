@testable import EngineerMemo
import XCTest

final class DateExtensionTest: XCTestCase {
    func test_toString_年月日の文字列を取得できること() {
        // arrange
        let date = Calendar.date(
            year: 2000,
            month: 1,
            day: 1
        )!

        // act
        let dateString = date.toString

        // assert
        XCTAssertEqual(
            dateString,
            "2000年1月1日"
        )
    }

    func test_ageString_起点日時に合わせた年齢を取得できること() {
        // arrange
        let now = Calendar.date(
            year: 2022,
            month: 1,
            day: 1
        )!

        let birthday = Calendar.date(
            year: 2000,
            month: 1,
            day: 1
        )!

        // act
        let age = birthday.ageString(now: now)

        // assert
        XCTAssertEqual(
            age,
            "22"
        )
    }

    func test_periodString_起点日時からの経過月を取得できること() {
        // arrange
        let start = Calendar.date(
            year: 2019,
            month: 12,
            day: 4
        )!

        let end = Calendar.date(
            year: 2021,
            month: 5,
            day: 2
        )!

        // act
        let period = start.periodString(end: end)

        // assert
        XCTAssertEqual(
            period,
            "16ヶ月"
        )
    }
}
