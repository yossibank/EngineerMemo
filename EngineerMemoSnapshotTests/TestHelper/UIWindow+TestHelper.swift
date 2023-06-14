import UIKit

extension UIWindow {
    static var connectedWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first {
            $0.session.configuration.delegateClass == SceneDelegateMock.self
        } as? UIWindowScene
    }

    static var windowFrame: CGRect {
        connectedWindowScene?.screen.bounds ?? .zero
    }
}
