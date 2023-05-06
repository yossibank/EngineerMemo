import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileBasicCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEditButtonPublisher = editButton.publisher(for: .touchUpInside)
    private(set) lazy var didTapSettingButtonPublisher = settingButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
        }
        .addSubview(editButton) {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(8)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var body: UIView {
        VStackView(spacing: 16) {
            VStackView(alignment: .center) {
                basicLabel.configure {
                    $0.text = L10n.Profile.basicInformation
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                }
            }

            settingView

            basicView
        }
    }

    private lazy var settingView = VStackView(
        alignment: .center,
        spacing: 16
    ) {
        UILabel().configure {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.text = L10n.Profile.settingDescription
            $0.textColor = .primary
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        settingButton.addConstraint {
            $0.width.equalTo(160)
            $0.height.equalTo(48)
        }
    }

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

    private let basicLabel = UILabel()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let genderLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let addressLabel = UILabel()
    private let stationLabel = UILabel()

    private let editButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.plain()
        config.title = L10n.Components.Button.Do.edit
        config.image = Asset.profileEdit.image
            .resized(size: .init(width: 16, height: 16))
            .withRenderingMode(.alwaysOriginal)
        config.baseForegroundColor = .primary
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.imagePadding = 4
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 12)
            return outgoing
        }
        config.background.cornerRadius = 8
        config.background.strokeColor = .primary
        config.background.strokeWidth = 1.0
        $0.configuration = config
    }

    private let settingButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.plain()
        config.title = L10n.Components.Button.Do.setting
        config.baseForegroundColor = .primary
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 16)
            return outgoing
        }
        config.background.backgroundColor = .grayButton
        config.background.cornerRadius = 8
        $0.configuration = config
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

            editButton.configuration?.background.strokeColor = .primary
        }
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject?) {
        guard let modelObject else {
            settingView.isHidden = false
            basicView.isHidden = true
            editButton.isHidden = true
            return
        }

        settingView.isHidden = true
        basicView.isHidden = false
        editButton.isHidden = false
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
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(32)
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
