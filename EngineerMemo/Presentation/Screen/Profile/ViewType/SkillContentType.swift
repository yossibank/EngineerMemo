enum SkillContentType: CaseIterable {
    case career

    var title: String {
        switch self {
        case .career: return L10n.Profile.career
        }
    }
}
