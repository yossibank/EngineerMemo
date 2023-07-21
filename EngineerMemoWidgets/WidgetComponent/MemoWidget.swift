import Intents
import SwiftUI
import WidgetKit

struct MemoWidget: Widget {
    let kind = "EngineerMemoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MemoWidgetPreviews: PreviewProvider {
    static var previews: some View {
        EntryView(
            entry: .init(
                date: .init(),
                configuration: .init()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
