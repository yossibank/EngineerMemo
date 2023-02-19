import SnapKit
import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleHeaderFooterView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel()
        .modifier(\.font, .boldSystemFont(ofSize: 12))

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension TitleHeaderFooterView {
    func configure(title: String) {
        titleLabel.modifier(\.text, title)
    }
}

// MARK: - private methods

private extension TitleHeaderFooterView {
    func setupViews() {
        contentView.modifier(\.backgroundColor, .thinGray)

        contentView.addSubview(titleLabel) {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct TitleHeaderFooterViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleHeaderFooterView()) {
                $0.configure(title: "Test")
            }
        }
    }
#endif
