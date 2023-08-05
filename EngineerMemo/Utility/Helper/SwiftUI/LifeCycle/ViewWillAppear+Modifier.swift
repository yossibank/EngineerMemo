import SwiftUI

extension View {
    func onViewWillAppear(_ perform: @escaping VoidBlock) -> some View {
        modifier(ViewWillAppearModifier(callback: perform))
    }
}

struct ViewWillAppearModifier: ViewModifier {
    let callback: VoidBlock

    func body(content: Content) -> some View {
        content
            .background(ViewWillAppearHandler(onWillAppear: callback))
    }
}

struct ViewWillAppearHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let onWillAppear: VoidBlock

    func makeCoordinator() -> Coordinator {
        .init(onWillAppear: onWillAppear)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: UIViewController {
        let onWillAppear: VoidBlock

        init(onWillAppear: @escaping VoidBlock) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}
