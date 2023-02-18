import Combine
import SnapKit
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileBasicCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var editButtonPublisher = editButton.publisher(for: .touchUpInside)

    private var body: UIView {
        VStackView {
            VStackView(spacing: 16) {
                VStackView(alignment: .center) {
                    basicLabel
                        .modifier(\.text, L10n.Profile.basicInformation)
                        .modifier(\.font, .boldSystemFont(ofSize: 16))

                    createStackView(.name)
                    createStackView(.age)
                    createStackView(.gender)
                    createStackView(.email)
                    createStackView(.phoneNumber)
                    createStackView(.address)
                    createStackView(.station)
                }
            }

            editButton
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 8)
                .modifier(\.clipsToBounds, true)
                .modifier(\.tintColor, .theme)
                .modifier(\.contentEdgeInsets, .init(top: 4, left: 8, bottom: 4, right: 8))
                .modifier(\.imageEdgeInsets, .init(top: 0, left: -8, bottom: 0, right: 0))
        }
        .modifier(\.backgroundColor, .thinGray)
        .modifier(\.clipsToBounds, true)
        .modifier(\.layer.cornerRadius, 8)
    }

    private let editButton = UIButton()
        .configure {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
            $0.setTitle(L10n.Components.Button.edit, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.setImage(ImageResources.edit, for: .normal)
        }

    private let basicLabel = UILabel()
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

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameLabel.modifier(\.text, modelObject.name)

        if let age = modelObject.birthday?.ageString() {
            ageLabel.modifier(\.text, age + L10n.Profile.old)
        } else {
            ageLabel.modifier(\.text, .noSetting)
        }

        genderLabel.modifier(\.text, modelObject.gender?.value ?? .noSetting)
        emailLabel.modifier(\.text, modelObject.email)
        phoneNumberLabel.modifier(\.text, modelObject.phoneNumber?.phoneText ?? .noSetting)
        addressLabel.modifier(\.text, modelObject.address)
        stationLabel.modifier(\.text, modelObject.station)
    }
}

// MARK: - private methods

private extension ProfileBasicCell {
    func setupViews() {
        contentView.modifier(\.backgroundColor, .primary)

        contentView.addSubview(body) {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.leading.trailing.equalToSuperview().inset(32)
            }
        }
    }

    private func createTitleLabel(_ type: ProfileContentType) -> UILabel {
        .init()
            .modifier(\.text, type.title)
            .modifier(\.textColor, .secondary)
            .modifier(\.font, .systemFont(ofSize: 14))
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
            valueLabel.modifier(\.numberOfLines, 0)

        case .phoneNumber:
            valueLabel = phoneNumberLabel

        case .address:
            valueLabel = addressLabel
            valueLabel.modifier(\.numberOfLines, 0)

        case .station:
            valueLabel = stationLabel
        }

        valueLabel.modifier(\.font, .boldSystemFont(ofSize: 16))

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
