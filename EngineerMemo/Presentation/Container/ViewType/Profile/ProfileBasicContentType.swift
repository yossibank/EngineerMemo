enum ProfileBasicContentType: CaseIterable {
    case name
    case age
    case gender
    case email
    case phoneNumber
    case address
    case station

    var title: String {
        switch self {
        case .name: return L10n.Profile.name
        case .age: return L10n.Profile.age
        case .gender: return L10n.Profile.gender
        case .email: return L10n.Profile.email
        case .phoneNumber: return L10n.Profile.phoneNumber
        case .address: return L10n.Profile.address
        case .station: return L10n.Profile.station
        }
    }
}
