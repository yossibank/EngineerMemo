import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileBasicCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEditButtonPublisher = editButton.publisher(
        for: .touchUpInside
    )

    private lazy var baseView = UIView()
        .addSubview(stackView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .addSubview(editButton) {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(8)
        }
        .configure {
            $0.backgroundColor = .thinGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var stackView: UIView {
        VStackView(spacing: 16) {
            VStackView(alignment: .center) {
                basicLabel.configure {
                    $0.text = L10n.Profile.basicInformation
                    $0.font = .boldSystemFont(ofSize: 16)
                }
            }

            VStackView(alignment: .leading, spacing: 16) {
                createStackView(.name)
                createStackView(.age)
                createStackView(.gender)
                createStackView(.email)
                createStackView(.phoneNumber)
                createStackView(.address)
                createStackView(.station)
            }
        }
    }

    private let basicLabel = UILabel()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let genderLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let addressLabel = UILabel()
    private let stationLabel = UILabel()

    private let editButton = UIButton(type: .system)
        .configure {
            $0.clipsToBounds = true
            $0.contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
            $0.imageEdgeInsets = .init(.left, -8)
            $0.tintColor = .theme
            $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
            $0.setTitle(L10n.Components.Button.edit, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.setImage(ImageResources.edit?.resized(size: .init(width: 16, height: 16)), for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
        }

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

            editButton.layer.borderColor = UIColor.theme.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameLabel.text = modelObject.name

        if let age = modelObject.birthday?.ageString() {
            ageLabel.text = "\(age)\(L10n.Profile.old)"
        } else {
            ageLabel.text = .noSetting
        }

        genderLabel.text = modelObject.gender?.value
        emailLabel.text = modelObject.email
        phoneNumberLabel.text = modelObject.phoneNumber?.phoneText
        addressLabel.text = modelObject.address
        stationLabel.text = modelObject.station
    }
}

// MARK: - private methods

private extension ProfileBasicCell {
    func setupView() {
        contentView.configure {
            $0.backgroundColor = .primary
        }

        contentView.addSubview(baseView) {
            $0.top.equalToSuperview()
            $0.bottom.leading.trailing.equalToSuperview().inset(32)
        }
    }

    private func createTitleLabel(_ type: ProfileContentType) -> UILabel {
        .init().configure {
            $0.text = type.title
            $0.textColor = .secondary
            $0.font = .systemFont(ofSize: 14)
        }
    }

    private func createStackView(_ type: ProfileContentType) -> UIStackView {
        let stackView: UIStackView
        let valueLabel: UILabel
        let titleLabel = createTitleLabel(type)

        switch type {
        case .name:
            valueLabel = nameLabel

        case .age:
            valueLabel = ageLabel

        case .gender:
            valueLabel = genderLabel

        case .email:
            valueLabel = emailLabel
            valueLabel.configure {
                $0.numberOfLines = 0
            }

        case .phoneNumber:
            valueLabel = phoneNumberLabel

        case .address:
            valueLabel = addressLabel
            valueLabel.configure {
                $0.numberOfLines = 0
            }

        case .station:
            valueLabel = stationLabel
        }

        valueLabel.font = .boldSystemFont(ofSize: 16)

        stackView = VStackView(alignment: .leading, spacing: 8) {
            titleLabel
            valueLabel
        }

        return stackView
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileBasicCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileBasicCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
