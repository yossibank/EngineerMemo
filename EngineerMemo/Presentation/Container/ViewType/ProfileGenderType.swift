enum ProfileGenderType: Int, CaseIterable {
    case man
    case woman
    case other
    case noSetting

    var title: String {
        switch self {
        case .man: return L10n.Profile.Gender.man
        case .woman: return L10n.Profile.Gender.woman
        case .other: return L10n.Profile.Gender.other
        case .noSetting: return .noSetting
        }
    }

    var gender: ProfileModelObject.Gender? {
        switch self {
        case .man: return .man
        case .woman: return .woman
        case .other: return .other
        case .noSetting: return nil
        }
    }

    static var defaultGender: ProfileModelObject.Gender = .noSetting

    static func menu(_ value: Int) -> Self {
        .init(rawValue: value) ?? .noSetting
    }
}
