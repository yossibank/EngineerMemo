import SwiftUI
import WidgetKit

struct MemoView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct MemoViewPreviews: PreviewProvider {
    static var previews: some View {
        MemoView(
            entry: .init(
                date: .init(),
                configuration: .init()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
