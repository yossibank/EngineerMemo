import FirebaseAnalytics

struct FirebaseAnalytics: FirebaseAnalyzable {
    var screenId: FAScreenId
}

extension FirebaseAnalytics {
    func sendEvent(_ name: String, parameters: [String: Any]) {
        let params = parameters.mapValues {
            $0 is String
                ? ($0 as! String).prefix(100)
                : $0
        }

        Analytics.logEvent(
            name,
            parameters: params
        )
    }

    func sendEvent(_ event: FAEvent) {
        var parameters = event.parameter
        parameters[FAParameter.screenId.rawValue] = screenId.rawValue

        sendEvent(
            event.name,
            parameters: parameters
        )

        if event != .screenView {
            Logger.info(message: "FAイベントを送信しました: \(event)")
        }
    }
}
