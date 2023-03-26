enum FAEvent: Equatable {
    case screenView

    var name: String {
        switch self {
        case .screenView:
            return L10n.Fa.EventName.screenView
        }
    }

    var parameter: [String: Any] {
        var params = [FAParameter: Any]()

        switch self {
        case .screenView:
            break
        }

        return params.reduce(into: [String: Any]()) {
            $0[$1.key.rawValue] = $1.value
        }
    }
}
