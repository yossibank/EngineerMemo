import SwiftUI

extension View {
    func onViewDidAppear(_ perform: @escaping VoidBlock) -> some View {
        modifier(ViewDidAppearModifier(callback: perform))
    }
}

struct ViewDidAppearModifier: ViewModifier {
    let callback: VoidBlock

    func body(content: Content) -> some View {
        content
            .background(ViewDidAppearHandler(onDidAppear: callback))
    }
}

struct ViewDidAppearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let onDidAppear: VoidBlock

    func makeCoordinator() -> Coordinator {
        .init(onDidAppear: onDidAppear)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: UIViewController {
        let onDidAppear: VoidBlock

        init(onDidAppear: @escaping VoidBlock) {
            self.onDidAppear = onDidAppear
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear()
        }
    }
}
