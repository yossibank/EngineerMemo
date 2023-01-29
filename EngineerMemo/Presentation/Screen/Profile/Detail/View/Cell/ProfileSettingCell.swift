import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfileSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var settingButtonTapPublisher = settingButton.publisher(
        for: .touchUpInside
    )

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .alignment(.center),
            .axis(.vertical),
            .backgroundColor(.thinGray),
            .clipsToBounds(true),
            .cornerRadius(8),
            .spacing(16)
        ]
    )

    private lazy var arrangedSubviews = [
        spaceTopView,
        titleLabel,
        settingButton,
        spaceBottomView
    ]

    private let spaceTopView = UIView()
    private let spaceBottomView = UIView()

    private let titleLabel = UILabel(
        styles: [
            .boldSystemFont(size: 14),
            .numberOfLines(0),
            .text(L10n.Profile.settingDescription),
            .textAlignment(.center)
        ]
    )

    private let settingButton = UIButton(
        styles: [
            .backgroundColor(.gray),
            .boldSystemFont(size: 14),
            .clipsToBounds(true),
            .cornerRadius(8),
            .setTitle(L10n.Components.Button.setting),
            .setTitleColor(.white)
        ]
    )

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupViews()
        setupConstraints()
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
    func setupViews() {
        contentView.apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        settingButton.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(56)
        }

        [spaceTopView, spaceBottomView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(16)
            }
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
