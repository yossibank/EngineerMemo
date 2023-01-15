import SnapKit
import UIKit

// MARK: - properties & init

final class ProfileTopCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        return $0
    }(UIStackView(arrangedSubviews: [
        iconImageView,
        userNameLabel
    ]))

    private let iconImageView = UIImageView()
    private let userNameLabel = UILabel(styles: [.bold14])

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
        iconImageView.image = ImageResources.profile
        userNameLabel.text = modelObject?.name
    }
}

// MARK: - private methods

private extension ProfileTopCell {
    func setupViews() {
        contentView.apply(.backgroundPrimary)
        contentView.addSubview(stackView)
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
