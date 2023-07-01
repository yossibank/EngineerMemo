import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSkillCell: AllyTableViewCell {
    private lazy var baseView = UIView()
        .addSubview(skillView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private lazy var skillView = VStackView(alignment: .leading, spacing: 16) {
        engineerCareerView
        languageView
        toeicView
    }

    private lazy var engineerCareerView = VStackView(alignment: .leading, spacing: 8) {
        UILabel().configure {
            $0.text = L10n.Profile.engineerCareer
            $0.textColor = .secondaryGray
            $0.font = .systemFont(ofSize: 14)
        }

        engineerCareerLabel.configure {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }

    private lazy var languageView = VStackView(alignment: .leading, spacing: 8) {
        UILabel().configure {
            $0.text = L10n.Profile.useLanguage
            $0.textColor = .secondaryGray
            $0.font = .systemFont(ofSize: 14)
        }

        HStackView(spacing: 8) {
            languageLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }

            languageCareerLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
    }

    private lazy var toeicView = VStackView(alignment: .leading, spacing: 8) {
        UILabel().configure {
            $0.text = L10n.Profile.toeic
            $0.textColor = .secondaryGray
            $0.font = .systemFont(ofSize: 14)
        }

        HStackView(spacing: 8) {
            toeicLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }

            toeicImageView
                .addConstraint {
                    $0.size.equalTo(24)
                }
                .configure {
                    $0.contentMode = .scaleAspectFill
                }
        }
    }

    private let engineerCareerLabel = UILabel()
    private let languageLabel = UILabel()
    private let languageCareerLabel = UILabel()
    private let toeicImageView = UIImageView()
    private let toeicLabel = UILabel()

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

extension ProfileSkillCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileSkillCell {
    func configure(_ modelObject: SkillModelObject) {
        engineerCareerView.isHidden = modelObject.engineerCareer.isNil
        languageView.isHidden = modelObject.language.isNil
        toeicView.isHidden = modelObject.toeic.isNil

        if let engineerCareer = modelObject.engineerCareer {
            engineerCareerLabel.text = SkillCareerType(rawValue: engineerCareer)?.title ?? .noSetting
        }

        if let language = modelObject.language {
            languageLabel.text = language

            if let languageCareer = modelObject.languageCareer {
                languageCareerLabel.text = SkillCareerType(rawValue: languageCareer)?.title
            }
        }

        if let toeic = modelObject.toeic {
            toeicLabel.text = L10n.Profile.score(toeic)
            setupToeicImage(toeic)
        }
    }
}

// MARK: - private methods

private extension ProfileSkillCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.verticalEdges.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }

        selectionStyle = .none
        backgroundColor = .background
    }

    func setupToeicImage(_ toeic: Int) {
        switch toeic {
        case 600 ... 730:
            toeicImageView.isHidden = false
            toeicImageView.image = Asset.bronzeTrophy.image

        case 731 ... 860:
            toeicImageView.isHidden = false
            toeicImageView.image = Asset.silverTrophy.image

        case 861 ... 990:
            toeicImageView.isHidden = false
            toeicImageView.image = Asset.goldTrophy.image

        default:
            toeicImageView.isHidden = true
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileSkillCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileSkillCell()) {
                $0.configure(
                    SKillModelObjectBuilder()
                        .toeic(990)
                        .build()
                )
            }
        }
    }
#endif
