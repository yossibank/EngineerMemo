import UIKit

protocol ContentView: UIView {
    func setupView()
}

final class NoContentView: UIView, ContentView {
    func setupView() {
        assertionFailure("実装する必要がありません")
    }
}
