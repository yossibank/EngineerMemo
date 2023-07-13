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
                    nameView.configure {
                        $0.setTitle(title: L10n.Profile.name)
                    }

                    careerView.configure {
                        $0.setTitle(title: L10n.Profile.engineerCareer)
                    }

                    languageView.configure {
                        $0.setTitle(title: L10n.Profile.useLanguage)
                    }

                    toeicView.configure {
                        $0.setTitle(title: L10n.Profile.toeic)
                    }
                }
            }
        }

        private let iconImageView = UIImageView().configure {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 30
        }

        private let nameView = TitleContentView()
        private let careerView = TitleContentView()
        private let languageView = TitleSubContentView()
        private let toeicView = TitleContentView()

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
            nameView.setContent(modelObject.name)

            if let engineerCareer = modelObject.skill?.engineerCareer {
                careerView.setContent(SkillCareerType(rawValue: engineerCareer)?.title ?? .noSetting)
            }

            if let language = modelObject.skill?.language {
                languageView.setContent(language)

                if let languageCareer = modelObject.skill?.languageCareer {
                    languageView.setSubTitle(SkillCareerType(rawValue: languageCareer)?.title)
                }
            } else {
                languageView.setContent(.noSetting)
            }

            if let toeic = modelObject.skill?.toeic {
                toeicView.setContent(L10n.Profile.score(toeic))
            } else {
                toeicView.setContent(.noSetting)
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
