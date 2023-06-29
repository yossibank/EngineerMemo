import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileNoSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapSettingButtonPublisher = settingButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(settingView) {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private lazy var settingView = VStackView(
        alignment: .center,
        spacing: 24
    ) {
        descriptionLabel.configure {
            $0.textColor = .primary
            $0.font = .boldSystemFont(ofSize: 14)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        settingButton.addConstraint {
            $0.width.equalTo(160)
            $0.height.equalTo(48)
        }
    }

    private let descriptionLabel = UILabel()

    private let settingButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
        config.title = L10n.Components.Button.Do.setting
        config.image = Asset.profileSetting.image
            .resized(size: .init(width: 28, height: 28))
            .withRenderingMode(.alwaysOriginal)
        config.baseForegroundColor = .primary
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.imagePadding = 4
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 16)
            return outgoing
        }
        config.background.backgroundColor = .primaryGray
        config.background.cornerRadius = 8
        config.background.strokeColor = .primary
        config.background.strokeWidth = 1.0
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - override methods

extension ProfileNoSettingCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileNoSettingCell {
    func configure(with description: String) {
        descriptionLabel.text = description
    }
}

// MARK: - private methods

private extension ProfileNoSettingCell {
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

    struct ProfileNoSettingCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileNoSettingCell())
        }
    }
#endif
