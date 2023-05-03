import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSkillCell: UITableViewCell {
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
            careerView
            toeicView
        }
    }

    private lazy var careerView = VStackView(
        alignment: .leading,
        spacing: 8
    ) {
        UILabel().configure {
            $0.text = L10n.Profile.engineerCareer
            $0.textColor = .secondaryGray
            $0.font = .systemFont(ofSize: 14)
        }

        engineerCareerLabel.configure {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }

    private let engineerCareerLabel = UILabel()

    private lazy var toeicView = VStackView(
        alignment: .leading,
        spacing: 8
    ) {
        UILabel().configure {
            $0.text = "TOEIC"
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

    private let toeicImageView = UIImageView()
    private let toeicLabel = UILabel()

    private let settingButton = UIButton(type: .system).configure {
        $0.setTitle(L10n.Components.Button.Do.setting, for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.backgroundColor = .grayButton
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
        careerView.isHidden = modelObject.engineerCareer == nil
        toeicView.isHidden = modelObject.toeic == nil

        if let engineerCareer = modelObject.engineerCareer {
            engineerCareerLabel.text = L10n.Profile.year(engineerCareer)
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
