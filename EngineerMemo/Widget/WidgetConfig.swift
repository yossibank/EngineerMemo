import WidgetKit

struct WidgetConfig {
    static func reload() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
