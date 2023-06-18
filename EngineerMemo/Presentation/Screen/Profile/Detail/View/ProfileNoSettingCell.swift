import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileNoSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapSettingButtonPublisher = settingButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(settingView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

    private lazy var settingView = VStackView(
        alignment: .center,
        spacing: 16
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
