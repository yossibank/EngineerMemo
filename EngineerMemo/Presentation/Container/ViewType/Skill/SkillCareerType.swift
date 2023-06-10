enum SkillCareerType: Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case more
    case noSetting

    var title: String {
        switch self {
        case .one: return L10n.Profile.year(1)
        case .two: return L10n.Profile.year(2)
        case .three: return L10n.Profile.year(3)
        case .four: return L10n.Profile.year(4)
        case .five: return L10n.Profile.year(5)
        case .six: return L10n.Profile.year(6)
        case .seven: return L10n.Profile.year(7)
        case .eight: return L10n.Profile.year(8)
        case .nine: return L10n.Profile.year(9)
        case .ten: return L10n.Profile.year(10)
        case .more: return L10n.Profile.moreTenYear
        case .noSetting: return .noSetting
        }
    }

    var value: Int? {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .more: return 99
        case .noSetting: return nil
        }
    }
}
