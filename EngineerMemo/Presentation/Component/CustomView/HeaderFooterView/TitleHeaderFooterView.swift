import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleHeaderFooterView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 12)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension TitleHeaderFooterView {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - private methods

private extension TitleHeaderFooterView {
    func setupView() {
        contentView.configure {
            $0.addSubview(titleLabel) {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(8)
            }

            $0.backgroundColor = .thinGray
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
