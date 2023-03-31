import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTopCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapIconChangeButtonPublisher = iconChangeButton.publisher(
        for: .touchUpInside
    )

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            iconImageView.configure {
                $0.contentMode = .scaleAspectFit
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 50
            }

            iconChangeButton.configure {
                $0.clipsToBounds = true
                $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
                $0.setTitle(L10n.Components.Button.changeProfileIcon, for: .normal)
                $0.setTitleColor(.theme, for: .normal)
                $0.layer.borderColor = UIColor.theme.cgColor
                $0.layer.borderWidth = 1.0
                $0.layer.cornerRadius = 8
            }

            userNameLabel.configure {
                $0.font = .boldSystemFont(ofSize: 14)
            }
        }
    }

    private let iconImageView = UIImageView()
        .addConstraint {
            $0.size.equalTo(100)
        }

    private let iconChangeButton = UIButton(type: .system)
        .addConstraint {
            $0.width.equalTo(140)
            $0.height.equalTo(28)
        }

    private let userNameLabel = UILabel()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            iconChangeButton.layer.borderColor = UIColor.theme.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileTopCell {
    func configure(_ modelObject: ProfileModelObject?) {
        if let data = modelObject?.iconImage,
           let image = UIImage(data: data) {
            iconImageView.image = image
        } else {
            iconImageView.image = Asset.penguin.image
        }

        userNameLabel.text = modelObject?.name?.notNoSettingText ?? L10n.Profile.noSettingName
    }
}

// MARK: - private methods

private extension ProfileTopCell {
    func setupView() {
        contentView.configure {
            $0.backgroundColor = .primary
        }

        contentView.addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileTopCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileTopCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
