import SwiftUI
import WidgetKit

struct MemoEmptyView: View {
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                Text(L10n.Widget.createMemo)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .padding(.all, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.primary))
                    )

                Image(uiImage: Asset.penguin.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
            }

            Text(L10n.Widget.emptyTitle)
                .font(.caption)
                .bold()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background))
    }
}

struct MemoEmptyViewPreviews: PreviewProvider {
    static var previews: some View {
        MemoEmptyView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
