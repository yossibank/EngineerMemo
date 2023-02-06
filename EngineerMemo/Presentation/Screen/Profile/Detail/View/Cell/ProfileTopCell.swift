import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfileTopCell: UITableViewCell {
    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .alignment(.center),
            .axis(.vertical),
            .spacing(16)
        ]
    )

    private lazy var arrangedSubviews = [
        iconImageView,
        userNameLabel
    ]

    private let iconImageView = UIImageView()
    private let userNameLabel = UILabel(style: .boldSystemFont(size: 14))

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension ProfileTopCell {
    func configure(_ modelObject: ProfileModelObject?) {
        iconImageView.apply(.image(ImageResources.profile))
        userNameLabel.apply(.text(modelObject?.name?.notNoSettingText ?? L10n.Profile.noSettingName))
    }
}

// MARK: - private methods

private extension ProfileTopCell {
    func setupViews() {
        contentView.apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(32)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(100)
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
