import SwiftUI

extension Text {
    func invalid() -> some View {
        font(.caption)
            .bold()
            .foregroundColor(.red)
    }
}
