#if DEBUG
    import Combine
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugProfileListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }
            .addSubview(iconImageView) {
                $0.top.trailing.equalToSuperview().inset(12)
                $0.size.equalTo(60)
            }
            .configure {
                $0.backgroundColor = .primaryGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }

        private var body: UIView {
            VStackView(spacing: 16) {
                VStackView(alignment: .center) {
                    UILabel().configure {
                        $0.text = L10n.Profile.basicInformation
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                    }
                }

                VStackView(alignment: .leading, spacing: 16) {
                    nameView.configure {
                        $0.setTitle(title: L10n.Profile.name)
                    }

                    ageView.configure {
                        $0.setTitle(title: L10n.Profile.age)
                    }

                    genderView.configure {
                        $0.setTitle(title: L10n.Profile.gender)
                    }

                    emailView.configure {
                        $0.setTitle(title: L10n.Profile.email)
                    }

                    phoneNumberView.configure {
                        $0.setTitle(title: L10n.Profile.phoneNumber)
                    }

                    addressView.configure {
                        $0.setTitle(title: L10n.Profile.address)
                    }

                    stationView.configure {
                        $0.setTitle(title: L10n.Profile.station)
                    }
                }
            }
        }

        private let iconImageView = UIImageView().configure {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 30
        }

        private let nameView = TitleContentView()
        private let ageView = TitleContentView()
        private let genderView = TitleContentView()
        private let emailView = TitleContentView()
        private let phoneNumberView = TitleContentView()
        private let addressView = TitleContentView()
        private let stationView = TitleContentView()

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
            nameView.setContent(modelObject.name)
            genderView.setContent(modelObject.gender?.value)
            emailView.setContent(modelObject.email)
            phoneNumberView.setContent(modelObject.phoneNumber?.phoneText)
            addressView.setContent(modelObject.address)
            stationView.setContent(modelObject.station)

            if let age = modelObject.birthday?.ageString() {
                ageView.setContent("\(age)\(L10n.Profile.old)")
            } else {
                ageView.setContent(.noSetting)
            }

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
                $0.addSubview(baseView) {
                    $0.verticalEdges.equalToSuperview().inset(8)
                    $0.horizontalEdges.equalToSuperview().inset(32)
                }

                $0.backgroundColor = .background
            }
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
