enum FAParameter: String {
    case screenId
    case userId

    var rawValue: String {
        switch self {
        case .screenId:
            return L10n.Fa.Parameter.screenId

        case .userId:
            return L10n.Fa.Parameter.userId
        }
    }
}
