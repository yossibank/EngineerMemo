import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTopCell: AllyTableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapIconChangeButtonPublisher = iconChangeButton.publisher(for: .touchUpInside)

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            iconImageView
                .addConstraint {
                    $0.size.equalTo(100)
                }
                .configure {
                    $0.contentMode = .scaleAspectFit
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 50
                }

            iconChangeButton
                .addConstraint {
                    $0.height.equalTo(28)
                }
                .configure {
                    var config = UIButton.Configuration.bordered()
                    config.title = L10n.Components.Button.changeProfileIcon
                    config.titleTextAttributesTransformer = .init { incoming in
                        var outgoing = incoming
                        outgoing.font = .boldSystemFont(ofSize: 12)
                        return outgoing
                    }
                    config.background.backgroundColor = .background
                    config.background.cornerRadius = 8
                    config.background.strokeColor = .primary
                    config.background.strokeWidth = 1.0
                    $0.configuration = config
                }

            userNameLabel.configure {
                $0.font = .boldSystemFont(ofSize: 14)
                $0.textColor = .primary
            }
        }
    }

    private let iconImageView = UIImageView()
    private let iconChangeButton = UIButton(type: .system)
    private let userNameLabel = UILabel()

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

extension ProfileTopCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ProfileTopCell {
    func configure(_ modelObject: ProfileModelObject?) {
        if let data = modelObject?.iconImage,
           let image = UIImage(data: data) {
            iconImageView.image = image
        } else {
            iconImageView.image = Asset.penguin.image
        }

        userNameLabel.text = modelObject?.name?.notNoSettingText ?? L10n.Profile.noSettingName
        iconChangeButton.isEnabled = modelObject != nil
        setupButton()
    }
}

// MARK: - private methods

private extension ProfileTopCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }
    }

    func setupButton() {
        let color: UIColor = iconChangeButton.isEnabled
            ? .primary
            : .primary.withAlphaComponent(0.3)

        iconChangeButton.configure {
            $0.configuration?.baseForegroundColor = color
            $0.configuration?.background.strokeColor = color
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileTopCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileTopCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
