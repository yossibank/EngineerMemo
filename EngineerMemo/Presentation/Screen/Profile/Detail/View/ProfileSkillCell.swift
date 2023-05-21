import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSkillCell: AllyTableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapSettingButtonPublisher = settingButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
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

            settingView
            skillView
        }
    }

    private lazy var settingView = VStackView(
        alignment: .center,
        spacing: 16
    ) {
        UILabel().configure {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.text = L10n.Profile.skillDescription
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        settingButton.addConstraint {
            $0.width.equalTo(160)
            $0.height.equalTo(48)
        }
    }

    private lazy var skillView = VStackView(
        alignment: .leading,
        spacing: 16
    ) {
        VStackView(alignment: .leading, spacing: 16) {
            engineerCareerView
            languageView
            toeicView
        }
    }

    private lazy var engineerCareerView = VStackView(
        alignment: .leading,
        spacing: 8
    ) {
        createLabel(.engineerCareer)

        engineerCareerLabel.configure {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }

    private let engineerCareerLabel = UILabel()

    private lazy var languageView = VStackView(
        alignment: .leading,
        spacing: 8
    ) {
        createLabel(.language)

        HStackView(spacing: 8) {
            languageLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }

            languageCareerLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
    }

    private let languageLabel = UILabel()
    private let languageCareerLabel = UILabel()

    private lazy var toeicView = VStackView(
        alignment: .leading,
        spacing: 8
    ) {
        createLabel(.toeic)

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

    private let toeicImageView = UIImageView()
    private let toeicLabel = UILabel()

    private let settingButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
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

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ProfileSkillCell {
    func configure(_ modelObject: SkillModelObject?) {
        guard let modelObject else {
            settingView.isHidden = false
            skillView.isHidden = true
            return
        }

        settingView.isHidden = true
        skillView.isHidden = false
        engineerCareerView.isHidden = modelObject.engineerCareer == nil
        languageView.isHidden = modelObject.language == nil
        toeicView.isHidden = modelObject.toeic == nil

        if let engineerCareer = modelObject.engineerCareer {
            engineerCareerLabel.text = L10n.Profile.year(engineerCareer)
        }

        if let language = modelObject.language {
            languageLabel.text = language

            if let languageCareer = modelObject.languageCareer {
                languageCareerLabel.text = L10n.Profile.year(languageCareer)
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
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }
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

    func createLabel(_ type: SkillContentType) -> UILabel {
        .init().configure {
            $0.text = type.title
            $0.textColor = .secondaryGray
            $0.font = .systemFont(ofSize: 14)
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
