import Intents
import SwiftUI
import WidgetKit

struct MemoWidget: Widget {
    let kind = "EngineerMemoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: MemoProvider()
        ) { entry in
            MemoView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
