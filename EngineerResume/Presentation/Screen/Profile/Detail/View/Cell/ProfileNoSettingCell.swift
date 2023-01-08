import Combine
import SnapKit
import UIKit

// MARK: - properties & init

final class ProfileNoSettingCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var settingButtonTapPublisher = settingButton.publisher(
        for: .touchUpInside
    )

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        $0.apply([.backgroundLightGray, .cornerRadius8])
        return $0
    }(UIStackView(arrangedSubviews: [
        titleLabel,
        settingButton,
        spaceBottomView
    ]))

    private let spaceTopView = UIView()
    private let spaceBottomView = UIView()

    private let titleLabel = UILabel(
        styles: [
            .bold14,
            .textCenter,
            .lineInfinity
        ]
    )

    private let settingButton = UIButton(
        styles: [
            .ButtonTitle.setting,
            .bold14,
            .titleWhite,
            .backgroundGray,
            .cornerRadius8
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
        setupConfigure()
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

private extension ProfileNoSettingCell {
    func setupViews() {
        apply(.backgroundPrimary)
        contentView.addSubview(stackView)
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
                $0.height.equalTo(4)
            }
        }
    }

    func setupConfigure() {
        titleLabel.text = "プロフィールを設定しましょう。\n職務経歴、自己PRなどをまとまることができます。"
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
