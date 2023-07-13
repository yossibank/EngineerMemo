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

    private let careerView = TitleContentView()
    private let languageView = TitleSubContentView()
    private let toeicView = TitleIconContentView()

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
        careerView.isHidden = modelObject.engineerCareer.isNil
        languageView.isHidden = modelObject.language.isNil
        toeicView.isHidden = modelObject.toeic.isNil

        if let engineerCareer = modelObject.engineerCareer {
            careerView.setContent(SkillCareerType(rawValue: engineerCareer)?.title ?? .noSetting)
        }

        if let language = modelObject.language {
            languageView.setContent(language)

            if let languageCareer = modelObject.languageCareer {
                languageView.setSubTitle(SkillCareerType(rawValue: languageCareer)?.title)
            }
        }

        if let toeic = modelObject.toeic {
            toeicView.setContent(L10n.Profile.score(toeic))
            toeicView.setIcon(toeic)
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
