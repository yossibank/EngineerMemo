import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class DebugContentView: UIView {
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

extension DebugContentView {}

// MARK: - private methods

private extension DebugContentView {}

// MARK: - protocol

extension DebugContentView: ContentView {
    func setupViews() {}
    func setupConstraints() {}
}
