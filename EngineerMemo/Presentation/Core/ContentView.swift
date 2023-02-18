import UIKit

protocol ContentView: UIView {
    func setupViews()
}

final class NoContentView: UIView, ContentView {
    func setupViews() {
        assertionFailure("実装する必要がありません")
    }
}
