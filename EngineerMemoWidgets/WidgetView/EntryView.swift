import SwiftUI
import WidgetKit

struct EntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct EntryViewPreviews: PreviewProvider {
    static var previews: some View {
        EntryView(
            entry: .init(
                date: .init(),
                configuration: .init()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
