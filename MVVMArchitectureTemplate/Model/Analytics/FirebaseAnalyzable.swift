/// @mockable
protocol FirebaseAnalyzable {
    var screenId: FAScreenId { get }

    func sendEvent(_ name: String, parameters: [String: Any])
    func sendEvent(_ event: FAEvent)
}
