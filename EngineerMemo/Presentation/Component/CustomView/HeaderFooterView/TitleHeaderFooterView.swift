import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class TitleHeaderFooterView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel(style: .boldSystemFont(size: 12))

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension TitleHeaderFooterView {
    func configure(title: String) {
        titleLabel.apply(.text(title))
    }
}

// MARK: - private methods

private extension TitleHeaderFooterView {
    func setupViews() {
        contentView.apply([
            .backgroundColor(.thinGray),
            .addSubview(titleLabel)
        ])
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints {
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
