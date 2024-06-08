enum ProfileGenderType: Int, CaseIterable {
    case man
    case woman
    case other
    case noSetting

    var title: String {
        switch self {
        case .man: L10n.Profile.Gender.man
        case .woman: L10n.Profile.Gender.woman
        case .other: L10n.Profile.Gender.other
        case .noSetting: .noSetting
        }
    }

    var gender: ProfileModelObject.Gender? {
        switch self {
        case .man: .man
        case .woman: .woman
        case .other: .other
        case .noSetting: nil
        }
    }
}
