import SwiftUI
import WidgetKit

struct MemoEntryView: View {
    var entry: MemoEntry

    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            MemoSmallView(entry: entry)

        case .systemMedium:
            MemoMediumView(entry: entry)

        default:
            MemoSmallView(entry: entry)
        }
    }
}
