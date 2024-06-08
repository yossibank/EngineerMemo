enum SkillCareerType: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case more = 99
    case noSetting = 0

    var title: String {
        switch self {
        case .one: L10n.Profile.year(1)
        case .two: L10n.Profile.year(2)
        case .three: L10n.Profile.year(3)
        case .four: L10n.Profile.year(4)
        case .five: L10n.Profile.year(5)
        case .six: L10n.Profile.year(6)
        case .seven: L10n.Profile.year(7)
        case .eight: L10n.Profile.year(8)
        case .nine: L10n.Profile.year(9)
        case .ten: L10n.Profile.year(10)
        case .more: L10n.Profile.moreTenYear
        case .noSetting: .noSetting
        }
    }

    var value: Int? {
        switch self {
        case .one: 1
        case .two: 2
        case .three: 3
        case .four: 4
        case .five: 5
        case .six: 6
        case .seven: 7
        case .eight: 8
        case .nine: 9
        case .ten: 10
        case .more: 99
        case .noSetting: nil
        }
    }
}
