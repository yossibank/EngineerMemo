import SwiftUI
import WidgetKit

struct MemoEmptyRectangularView: View {
    var body: some View {
        HStack {
            Text(L10n.Widget.emptyTitle)
                .font(.caption)

            Image(uiImage: Asset.warn.image)
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding(.all, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MemoEmptyRectangularView_Previews: PreviewProvider {
    static var widgetFamily: WidgetFamily {
        if #available(iOSApplicationExtension 16.0, *) {
            return .accessoryRectangular
        } else {
            return .systemSmall
        }
    }

    static var previews: some View {
        MemoEmptyRectangularView()
            .previewContext(WidgetPreviewContext(family: widgetFamily))
    }
}
