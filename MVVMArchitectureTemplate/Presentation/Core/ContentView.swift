import UIKit

protocol ContentView: UIView {
    func setupViews()
    func setupConstraints()
}

final class NoContentView: UIView, ContentView {
    func setupViews() {
        assertionFailure("実装する必要がありません")
    }

    func setupConstraints() {
        assertionFailure("実装する必要がありません")
    }
}
