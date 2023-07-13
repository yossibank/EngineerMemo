import UIKit
import UIKitHelper

// MARK: - properties & init

final class DetailTitleIconView: UIView {
    private var body: UIView {
        VStackView(spacing: 8) {
            HStackView(spacing: 8) {
                titleIconImageView.addConstraint {
                    $0.size.equalTo(24)
                }

                titleLabel.configure {
                    $0.textColor = .secondaryGray
                    $0.font = .boldSystemFont(ofSize: 16)
                }

                UIView()
            }

            BorderView().configure {
                $0.changeColor(.secondaryGray)
            }

            HStackView(spacing: 8) {
                iconImageView.addConstraint {
                    $0.size.equalTo(24)
                }

                contentLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.numberOfLines = 0
                }
            }
        }
    }

    private let titleIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let contentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension DetailTitleIconView {
    func setTitle(
        title: String?,
        icon: UIImage?
    ) {
        titleLabel.text = title
        titleIconImageView.image = icon
    }

    func setContent(_ text: String?) {
        contentLabel.text = text
    }

    func setIcon(_ icon: UIImage?) {
        iconImageView.image = icon
    }
}

// MARK: - private methods

private extension DetailTitleIconView {
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

    struct DetailTitleIconViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DetailTitleIconView())
        }
    }
#endif
