import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileIconCell: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    override var isSelected: Bool {
        didSet {
            spaceView.isHidden = isSelected
            checkImageView.isHidden = !isSelected
        }
    }

    private var body: UIView {
        VStackView(alignment: .center, spacing: 8) {
            iconImageView
                .addConstraint {
                    $0.size.equalTo(120)
                }
                .configure {
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 60
                }

            iconLabel.configure {
                $0.font = .boldSystemFont(ofSize: 14)
                $0.numberOfLines = 1
            }

            spaceView
                .addConstraint {
                    $0.size.equalTo(24)
                }
                .configure {
                    $0.backgroundColor = .clear
                }

            checkImageView
                .addConstraint {
                    $0.size.equalTo(24)
                }
                .configure {
                    $0.image = Asset.check.image
                    $0.isHidden = true
                }
        }
    }

    private let iconImageView = UIImageView()
    private let iconLabel = UILabel()
    private let spaceView = UIView()
    private let checkImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ProfileIconCell {
    func configure(
        icon: UIImage,
        title: String
    ) {
        iconImageView.image = icon
        iconLabel.text = title
    }
}

// MARK: - private methods

private extension ProfileIconCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .primary
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileIconCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileIconCell()) {
                $0.configure(
                    icon: Asset.penguin.image,
                    title: L10n.Profile.Icon.penguin
                )
            }
            .frame(width: 180, height: 180)
        }
    }
#endif
