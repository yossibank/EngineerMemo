import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileBasicCell: AllyTableViewCell {
    private lazy var baseView = UIView()
        .addSubview(basicView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private lazy var basicView = VStackView(
        alignment: .leading,
        spacing: 16
    ) {
        createStackView(.name)
        createStackView(.age)
        createStackView(.gender)
        createStackView(.email)
        createStackView(.phoneNumber)
        createStackView(.address)
        createStackView(.station)
    }

    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let genderLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let addressLabel = UILabel()
    private let stationLabel = UILabel()

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
}

// MARK: - override methods

extension ProfileBasicCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameLabel.text = modelObject.name
        genderLabel.text = modelObject.gender?.value
        emailLabel.text = modelObject.email
        phoneNumberLabel.text = modelObject.phoneNumber?.phoneText
        addressLabel.text = modelObject.address
        stationLabel.text = modelObject.station

        if let age = modelObject.birthday?.ageString() {
            ageLabel.text = "\(age)\(L10n.Profile.old)"
        } else {
            ageLabel.text = .noSetting
        }
    }
}

// MARK: - private methods

private extension ProfileBasicCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.verticalEdges.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }
    }

    private func createStackView(_ type: ProfileContentType) -> UIStackView {
        let valueLabel: UILabel

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

        return VStackView(alignment: .leading, spacing: 8) {
            UILabel().configure {
                $0.text = type.title
                $0.textColor = .secondaryGray
                $0.font = .systemFont(ofSize: 14)
            }

            valueLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
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
