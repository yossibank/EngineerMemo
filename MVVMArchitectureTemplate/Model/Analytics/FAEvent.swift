enum FAEvent: Equatable {
    case screenView
    case tapSmapleList(userId: Int)

    var name: String {
        switch self {
        case .screenView:
            return L10n.Fa.EventName.screenView

        case .tapSmapleList:
            return L10n.Fa.EventName.tapSampleList
        }
    }

    var parameter: [String: Any] {
        var params = [FAParameter: Any]()

        switch self {
        case .screenView:
            break

        case let .tapSmapleList(userId):
            params[.userId] = userId
        }

        return params.reduce(into: [String: Any]()) {
            $0[$1.key.rawValue] = $1.value
        }
    }
}
