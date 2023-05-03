enum SkillContentType: CaseIterable {
    case engineerCareer

    var title: String {
        switch self {
        case .engineerCareer: return L10n.Profile.engineerCareer
        }
    }
}
