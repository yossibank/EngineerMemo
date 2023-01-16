import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class DebugProfileCreateContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension DebugProfileCreateContentView {}

// MARK: - private methods

private extension DebugProfileCreateContentView {}

// MARK: - protocol

extension DebugProfileCreateContentView: ContentView {
    func setupViews() {
        backgroundColor = .red
    }

    func setupConstraints() {}
}
