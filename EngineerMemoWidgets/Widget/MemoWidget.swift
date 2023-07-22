import Intents
import SwiftUI
import WidgetKit

struct MemoWidget: Widget {
    private let kind = "EngineerMemoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: MemoProvider()
        ) { entry in
            MemoView(entry: entry)
        }
        .configurationDisplayName(L10n.Widget.configurationDisplayName)
        .description(L10n.Widget.description)
    }
}
