import SwiftUI

extension View {
    func onViewDidLoad(_ perform: @escaping VoidBlock) -> some View {
        modifier(ViewDidLoadModifier(callback: perform))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    let callback: VoidBlock

    func body(content: Content) -> some View {
        content
            .background(ViewDidLoadHandler(onDidLoad: callback))
    }
}

struct ViewDidLoadHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let onDidLoad: VoidBlock

    func makeCoordinator() -> Coordinator {
        .init(onDidLoad: onDidLoad)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: UIViewController {
        let onDidLoad: VoidBlock

        init(onDidLoad: @escaping VoidBlock) {
            self.onDidLoad = onDidLoad
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            onDidLoad()
        }
    }
}
