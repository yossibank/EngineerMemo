import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class SettingTitleContentCell: UICollectionViewCell {
    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(8)
        }
        .apply(.borderView)

    private lazy var body = HStackView(alignment: .center, spacing: 4) {
        titleLabel.configure {
            $0.font = .boldSystemFont(ofSize: 13)
        }

        UIView()

        valueLabel.configure {
            $0.font = .boldSystemFont(ofSize: 16)
        }

        disclosure.configure {
            $0.image = Asset.disclosure.image
                .resized(size: .init(width: 16, height: 16))
                .withRenderingMode(.alwaysOriginal)
        }
    }

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let disclosure = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension SettingTitleContentCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension SettingTitleContentCell {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func updateValue(_ text: String?) {
        valueLabel.text = text
    }

    func showDisclosure(_ isShow: Bool) {
        disclosure.isHidden = !isShow
    }
}

// MARK: - private methods

private extension SettingTitleContentCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct TitleContentCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SettingTitleContentCell())
        }
    }
#endif
