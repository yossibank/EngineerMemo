import Intents
import SwiftUI
import WidgetKit

struct MemoWidget: Widget {
    @ArrayBuilder<WidgetFamily>
    private var supportedFamilies: [WidgetFamily] {
        WidgetFamily.systemSmall
        WidgetFamily.systemMedium
        WidgetFamily.systemLarge

        if #available(iOSApplicationExtension 16.0, *) {
            WidgetFamily.accessoryRectangular
        }
    }

    private let kind = "EngineerMemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: MemoProvider()
        ) { entry in
            MemoEntryView(entry: entry)
        }
        .configurationDisplayName(L10n.Widget.configurationDisplayName)
        .description(L10n.Widget.description)
        .supportedFamilies(supportedFamilies)
    }
}
