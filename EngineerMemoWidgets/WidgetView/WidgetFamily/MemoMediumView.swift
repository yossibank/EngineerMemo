import SwiftUI
import WidgetKit

struct MemoMediumView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        if let memo = entry.memoList.first {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.Memo.title)
                            .foregroundColor(Color(.secondaryGray))
                            .font(.system(size: 10))

                        Text(memo.title ?? .noSetting)
                            .font(.subheadline)
                            .bold()
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(uiImage: Asset.penguin.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Memo.content)
                        .foregroundColor(Color(.secondaryGray))
                        .font(.system(size: 10))

                    Text(memo.content ?? .noSetting)
                        .font(.subheadline)
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
    struct MemoMediumViewPreviews: PreviewProvider {
        static var previews: some View {
            MemoMediumView(
                entry: .init(
                    date: .init(),
                    memoList: [
                        MemoModelObjectBuilder()
                            .title("title".repeat(5))
                            .content("content".repeat(5))
                            .build()
                    ]
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
#endif
