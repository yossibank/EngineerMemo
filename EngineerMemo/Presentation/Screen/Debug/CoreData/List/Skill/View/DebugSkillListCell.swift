#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugSkillListCell: UITableViewCell {
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
                        $0.text = L10n.Profile.experienceSkill
                        $0.font = .boldSystemFont(ofSize: 16)
                    }
                }

                VStackView(alignment: .leading, spacing: 16) {
                    VStackView(alignment: .leading, spacing: 8) {
                        UILabel().configure {
                            $0.text = L10n.Profile.name
                            $0.textColor = .secondaryGray
                            $0.font = .systemFont(ofSize: 14)
                        }

                        nameLabel.configure {
                            $0.textColor = .primary
                            $0.font = .boldSystemFont(ofSize: 16)
                        }
                    }

                    createStackView(.engineerCareer)
                    createStackView(.language)
                    createStackView(.toeic)
                }
            }
        }

        private let nameLabel = UILabel()
        private let engineerCareerLabel = UILabel()
        private let languageLabel = UILabel()
        private let toeicLabel = UILabel()

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

    extension DebugSkillListCell {
        func configure(_ modelObject: ProfileModelObject) {
            nameLabel.text = modelObject.name

            if let engineerCareer = modelObject.skill?.engineerCareer {
                engineerCareerLabel.text = L10n.Profile.year(engineerCareer)
            } else {
                engineerCareerLabel.text = .noSetting
            }

            if let language = modelObject.skill?.language,
               let languageCareer = modelObject.skill?.languageCareer {
                languageLabel.text = language + " " + L10n.Profile.year(languageCareer)
            } else if let language = modelObject.skill?.language {
                languageLabel.text = language
            }

            if let toeic = modelObject.skill?.toeic {
                toeicLabel.text = L10n.Profile.score(toeic)
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

    private extension DebugSkillListCell {
        func setupView() {
            contentView.configure {
                $0.addSubview(baseView) {
                    $0.verticalEdges.equalToSuperview().inset(8)
                    $0.horizontalEdges.equalToSuperview().inset(32)
                }

                $0.backgroundColor = .background
            }
        }

        func createStackView(_ type: SkillContentType) -> UIStackView {
            let valueLabel: UILabel

            switch type {
            case .engineerCareer:
                valueLabel = engineerCareerLabel

            case .language:
                valueLabel = languageLabel

            case .toeic:
                valueLabel = toeicLabel
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

    struct DebugSkillListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugSkillListCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
