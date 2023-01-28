import Foundation

extension Calendar {
    static func date(
        year: Int,
        month: Int,
        day: Int
    ) -> Date? {
        let calender = Calendar(identifier: .gregorian)

        return calender.date(
            from: .init(
                year: year,
                month: month,
                day: day
            )
        )
    }
}
