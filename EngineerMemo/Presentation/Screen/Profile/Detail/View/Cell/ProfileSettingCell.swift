import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var settingButtonTapPublisher = settingButton.publisher(
        for: .touchUpInside
    )

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            spaceTopView

            titleLabel
                .modifier(\.font, .boldSystemFont(ofSize: 14))
                .modifier(\.numberOfLines, 0)
                .modifier(\.text, L10n.Profile.settingDescription)
                .modifier(\.textAlignment, .center)

            settingButton
                .modifier(\.backgroundColor, .gray)
                .modifier(\.clipsToBounds, true)
                .modifier(\.layer.cornerRadius, 8)

            spaceBottomView
        }
        .modifier(\.backgroundColor, .thinGray)
        .modifier(\.clipsToBounds, true)
        .modifier(\.layer.cornerRadius, 8)
    }

    private let spaceTopView = UIView()
        .addConstraint {
            $0.height.equalTo(16)
        }

    private let spaceBottomView = UIView()
        .addConstraint {
            $0.height.equalTo(16)
        }

    private let titleLabel = UILabel()
        .addConstraint {
            $0.leading.trailing.equalToSuperview().inset(16)
        }

    private let settingButton = UIButton(type: .system)
        .addConstraint {
            $0.width.equalTo(180)
            $0.height.equalTo(56)
        }
        .configure {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.setTitle(L10n.Components.Button.setting, for: .normal)
            $0.setTitleColor(.white, for: .normal)
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

// MARK: - private methods

private extension ProfileSettingCell {
    func setupView() {
        contentView.modifier(\.backgroundColor, .primary)

        contentView.addSubview(body) {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
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
