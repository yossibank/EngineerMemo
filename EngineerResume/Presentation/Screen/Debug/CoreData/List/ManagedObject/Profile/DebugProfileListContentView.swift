import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class DebugProfileListContentView: UIView {
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

extension DebugProfileListContentView {}

// MARK: - private methods

private extension DebugProfileListContentView {}

// MARK: - protocol

extension DebugProfileListContentView: ContentView {
    func setupViews() {}
    func setupConstraints() {}
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct DebugProfileListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugProfileListContentView()
            )
        }
    }
#endif
