#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugProfileListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .addSubview(stackView) {
                $0.edges.equalToSuperview().inset(16)
            }
            .addSubview(iconImageView) {
                $0.top.trailing.equalToSuperview().inset(12)
                $0.size.equalTo(60)
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

        private let iconImageView = UIImageView().configure {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 30
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
    }

    // MARK: - internal methods

    extension DebugProfileListCell {
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

            if let data = modelObject.iconImage,
               let image = UIImage(data: data) {
                iconImageView.image = image
            } else {
                iconImageView.image = Asset.penguin.image
            }
        }
    }

    // MARK: - private methods

    private extension DebugProfileListCell {
        func setupView() {
            contentView.configure {
                $0.backgroundColor = .primary
            }

            contentView.addSubview(baseView) {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview().inset(32)
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

    struct DebugProfileListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileListCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
