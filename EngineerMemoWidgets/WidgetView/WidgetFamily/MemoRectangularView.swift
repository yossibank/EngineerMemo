import SwiftUI
import WidgetKit

struct MemoRectangularView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MemoRectangularViewPreviews: PreviewProvider {
    static var widgetFamily: WidgetFamily {
        if #available(iOSApplicationExtension 16.0, *) {
            return .accessoryRectangular
        } else {
            return .systemSmall
        }
    }

    static var previews: some View {
        MemoRectangularView(
            entry: .init(
                date: .init(),
                memoList: [
                    MemoModelObjectBuilder()
                        .title("title".repeat(1))
                        .content("content".repeat(1))
                        .build()
                ]
            )
        )
        .previewContext(WidgetPreviewContext(family: widgetFamily))
    }
}
