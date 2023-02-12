import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ___FILEBASENAME___: UICollectionReusableView {
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

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {
    func setupViews() {}
    func setupConstraints() {}
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ___FILEBASENAME___Preview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ___FILEBASENAME___()
            )
        }
    }
#endif
