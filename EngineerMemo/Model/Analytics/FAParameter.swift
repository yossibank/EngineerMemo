enum FAParameter: String {
    case screenId

    var rawValue: String {
        switch self {
        case .screenId:
            return L10n.Fa.Parameter.screenId
        }
    }
}
