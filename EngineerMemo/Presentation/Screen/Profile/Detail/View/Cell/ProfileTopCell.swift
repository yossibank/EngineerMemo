import SnapKit
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTopCell: UITableViewCell {
    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            iconImageView

            userNameLabel
                .modifier(\.font, .boldSystemFont(ofSize: 14))
        }
    }

    private let iconImageView = UIImageView()
        .configure {
            $0.snp.makeConstraints {
                $0.size.equalTo(100)
            }
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

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension ProfileTopCell {
    func configure(_ modelObject: ProfileModelObject?) {
        iconImageView.modifier(\.image, ImageResources.profile)
        userNameLabel.modifier(\.text, modelObject?.name?.notNoSettingText ?? L10n.Profile.noSettingName)
    }
}

// MARK: - private methods

private extension ProfileTopCell {
    func setupViews() {
        contentView.modifier(\.backgroundColor, .primary)

        contentView.addSubview(body) {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(16)
            }
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
