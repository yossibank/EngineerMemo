import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapSettingButtonPublisher = settingButton.publisher(for: .touchUpInside)

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16, layoutMargins: .init(.horizontal, 16)) {
            spaceTopView.addConstraint {
                $0.height.equalTo(16)
            }

            titleLabel.configure {
                $0.font = .boldSystemFont(ofSize: 14)
                $0.text = L10n.Profile.settingDescription
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }

            settingButton
                .addConstraint {
                    $0.width.equalTo(180)
                    $0.height.equalTo(56)
                }
                .configure {
                    $0.setTitle(
                        L10n.Components.Button.setting,
                        for: .normal
                    )
                    $0.setTitleColor(
                        .white,
                        for: .normal
                    )
                    $0.backgroundColor = .gray
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 8
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
                }

            spaceBottomView.addConstraint {
                $0.height.equalTo(16)
            }
        }
        .configure {
            $0.backgroundColor = .thinGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
    }

    private let spaceTopView = UIView()
    private let spaceBottomView = UIView()
    private let titleLabel = UILabel()
    private let settingButton = UIButton(type: .system)

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

// MARK: - private methods

private extension ProfileSettingCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .primary
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileSettingCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileSettingCell())
        }
    }
#endif
