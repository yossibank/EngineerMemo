import SwiftUI
import WidgetKit

struct MemoRectangularView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        if let memo = entry.memoList.first {
            VStack {
                Text(memo.title ?? .noSetting)
                    .font(.caption)
                    .bold()
                    .lineLimit(3)
            }
            .padding(.all, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .widgetURL(AppURLScheme.memoDetail.schemeURL(queryItems: [.identifier(memo.identifier)]))
        } else {
            MemoEmptyRectangularView()
                .widgetURL(AppURLScheme.memoCreate.schemeURL())
        }
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
                        .title("title".repeat(100))
                        .content("content".repeat(1))
                        .build()
                ]
            )
        )
        .previewContext(WidgetPreviewContext(family: widgetFamily))
    }
}
