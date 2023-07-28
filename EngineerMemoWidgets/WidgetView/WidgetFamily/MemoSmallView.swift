import SwiftUI
import WidgetKit

struct MemoSmallView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        if let memo = entry.memoList.first {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.Memo.title)
                            .foregroundColor(Color(.secondaryGray))
                            .font(.system(size: 7))

                        Text(memo.title ?? .noSetting)
                            .font(.caption)
                            .bold()
                            .lineLimit(3)
                    }

                    Spacer()

                    Image(uiImage: Asset.penguin.image)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .cornerRadius(16)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Memo.content)
                        .foregroundColor(Color(.secondaryGray))
                        .font(.system(size: 7))

                    Text(memo.content ?? .noSetting)
                        .font(.caption)
                        .bold()
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.background))
            .widgetURL(AppURLScheme.memoDetail.schemeURL(queryItems: [.identifier(memo.identifier)]))
        } else {
            MemoEmptyView()
                .widgetURL(AppURLScheme.memoCreate.schemeURL())
        }
    }
}

#if DEBUG
    struct MemoSmallViewPreviews: PreviewProvider {
        static var previews: some View {
            MemoSmallView(
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
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
#endif
