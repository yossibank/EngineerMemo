enum SkillContentType: CaseIterable {
    case engineerCareer
    case language
    case toeic

    var title: String {
        switch self {
        case .engineerCareer: return L10n.Profile.engineerCareer
        case .language: return L10n.Profile.useLanguage
        case .toeic: return L10n.Profile.toeic
        }
    }
}
