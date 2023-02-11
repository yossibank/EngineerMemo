import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class MemoListContentView: UIView {
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

extension MemoListContentView {}

// MARK: - private methods

private extension MemoListContentView {}

// MARK: - protocol

extension MemoListContentView: ContentView {
    func setupViews() {}
    func setupConstraints() {}
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoListContentView()
            )
        }
    }
#endif
