import SwiftUI
import WidgetKit

struct MemoSmallView: View {
    var entry: MemoProvider.Entry

    var body: some View {
        if let memo = entry.memoList.first {
            VStack(spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.Memo.title)
                            .font(.system(size: 7))

                        Text(memo.title ?? .noSetting)
                            .font(.caption)
                            .bold()
                            .lineLimit(2)
                    }

                    Image(uiImage: Asset.penguin.image)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .cornerRadius(16)
                        .padding(.trailing, 8)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Memo.content)
                        .font(.system(size: 7))

                    Text(memo.content ?? .noSetting)
                        .font(.caption)
                        .bold()
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, 8)
            .frame(maxHeight: .infinity)
            .background(Color(.background))
        } else {
            MemoEmptyView()
        }
    }
}

struct MemoSmallViewPreviews: PreviewProvider {
    static var previews: some View {
        MemoSmallView(
            entry: .init(
                date: .init(),
                memoList: [
                    MemoModelObjectBuilder()
                        .title("title ".repeat(7))
                        .content("content ".repeat(7))
                        .build()
                ]
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
