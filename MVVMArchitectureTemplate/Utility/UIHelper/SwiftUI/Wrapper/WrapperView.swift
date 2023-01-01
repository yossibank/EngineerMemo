import SwiftUI

struct WrapperView<View: UIView>: UIViewRepresentable {
    let view: View

    var configuration: ((View) -> Void)?

    func makeUIView(context: Context) -> View {
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }

    func updateUIView(_ uiView: View, context: Context) {
        configuration?(uiView)
    }
}
