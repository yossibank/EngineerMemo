import UIKit
import UIKitHelper

// MARK: - properties & init

final class UpdateTitleView: UIView {
    private var body: UIView {
        VStackView {
            titleView
                .addSubview(titleStackView) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)
        }
    }

    private lazy var titleStackView = HStackView(spacing: 4) {
        titleIconImageView
            .addConstraint {
                $0.size.equalTo(24)
            }

        titleLabel.configure {
            $0.textColor = .secondaryGray
            $0.font = .boldSystemFont(ofSize: 16)
        }

        UIView()
    }

    private let titleView = UIView()
    private let titleIconImageView = UIImageView()
    private let titleLabel = UILabel()

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

extension UpdateTitleView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            titleView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension UpdateTitleView {
    func configure(
        title: String?,
        icon: UIImage?
    ) {
        titleLabel.text = title
        titleIconImageView.image = icon
    }
}

// MARK: - private methods

private extension UpdateTitleView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct UpdateTitleViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UpdateTitleView())
        }
    }
#endif
