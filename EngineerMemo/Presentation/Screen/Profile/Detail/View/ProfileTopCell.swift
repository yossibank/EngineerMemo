import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTopCell: UITableViewCell {
    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            iconImageView.configure {
                $0.contentMode = .scaleAspectFit
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
}

// MARK: - internal methods

extension ProfileTopCell {
    func configure(_ modelObject: ProfileModelObject?) {
        if let data = modelObject?.iconImage,
           let image = UIImage(data: data) {
            iconImageView.image = image
        } else {
            iconImageView.image = ImageResources.profile
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
