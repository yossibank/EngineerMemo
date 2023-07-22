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
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: MemoProvider()
        ) { entry in
            MemoView(entry: entry)
                .environment(\.managedObjectContext, CoreDataManager.shared.backgroundContext)
        }
        .configurationDisplayName(L10n.Widget.configurationDisplayName)
        .description(L10n.Widget.description)
        .supportedFamilies(supportedFamilies)
    }
}
