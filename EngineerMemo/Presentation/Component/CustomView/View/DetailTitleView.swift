import UIKit

// MARK: - properties & init

final class DetailTitleView: UIView {
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

            contentLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
                $0.numberOfLines = 0
            }
        }
    }

    private let titleIconImageView = UIImageView()
    private let titleLabel = UILabel()
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

extension DetailTitleView {
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
}

// MARK: - private methods

private extension DetailTitleView {
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

    struct DetailTitleViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DetailTitleView())
        }
    }
#endif
