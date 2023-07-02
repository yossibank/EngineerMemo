import Foundation

extension Date {
    enum Formatter {
        static let dateFormatter = DateFormatter()
    }

    var toString: String {
        let formatter = Formatter.dateFormatter
        formatter.dateFormat = "yyyy'年'M'月'd'日"
        formatter.locale = .japan
        formatter.timeZone = .tokyo
        return formatter.string(from: self)
    }

    func ageString(now: Date = .init()) -> String? {
        let calendar = Calendar.current

        guard let now = calendar.dateComponents(
            [.calendar, .year, .month, .day],
            from: now
        ).date else {
            return nil
        }

        guard let birthday = calendar.dateComponents(
            [.calendar, .year, .month, .day],
            from: self
        ).date else {
            return nil
        }

        return calendar.dateComponents(
            [.year],
            from: birthday,
            to: now
        ).year?.description
    }

    func periodString(end: Date?) -> String? {
        guard
            let end,
            let period = Calendar.current.dateComponents(
                [.month],
                from: self,
                to: end
            ).month?.description
        else {
            return nil
        }

        return period + "ヶ月"
    }
}
