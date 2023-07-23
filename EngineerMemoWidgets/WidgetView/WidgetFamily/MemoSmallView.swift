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
                            .font(.system(size: 7))

                        Text(memo.title ?? .noSetting)
                            .font(.caption)
                            .bold()
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(uiImage: Asset.penguin.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                        .padding(.top, -8)
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
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        .title("title".repeat(1))
                        .content("content".repeat(1))
                        .build()
                ]
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
