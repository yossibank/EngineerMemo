import UIKit

// MARK: - properties & init

final class TitleIconContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .leading, spacing: 8) {
            titleLabel.configure {
                $0.textColor = .secondaryGray
                $0.font = .systemFont(ofSize: 14)
            }

            HStackView(spacing: 8) {
                contentLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.numberOfLines = 0
                }

                iconImageView
                    .addConstraint {
                        $0.size.equalTo(24)
                    }
                    .configure {
                        $0.contentMode = .scaleAspectFill
                    }
            }
        }
    }

    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let iconImageView = UIImageView()

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

extension TitleIconContentView {
    func setTitle(title: String) {
        titleLabel.text = title
    }

    func setContent(_ text: String?) {
        contentLabel.text = text
    }

    func setIcon(_ score: Int) {
        switch score {
        case 600 ... 730:
            iconImageView.isHidden = false
            iconImageView.image = Asset.bronzeTrophy.image

        case 731 ... 860:
            iconImageView.isHidden = false
            iconImageView.image = Asset.silverTrophy.image

        case 861 ... 990:
            iconImageView.isHidden = false
            iconImageView.image = Asset.goldTrophy.image

        default:
            iconImageView.isHidden = true
        }
    }
}

// MARK: - private methods

private extension TitleIconContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct TitleIconContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleIconContentView()) {
                $0.setTitle(title: "title")
                $0.setContent("value")
                $0.setIcon(800)
            }
            .frame(height: 60)
        }
    }
#endif
