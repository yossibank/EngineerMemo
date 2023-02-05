import Combine
import SnapKit
import UIKit
import UIStyle

enum ProfileMenuGenderType: Int, CaseIterable {
    case man = 0
    case woman
    case other
    case none

    var title: String {
        switch self {
        case .man: return L10n.Profile.Gender.man
        case .woman: return L10n.Profile.Gender.woman
        case .other: return L10n.Profile.Gender.other
        case .none: return .noSetting
        }
    }

    var gender: ProfileModelObject.Gender {
        switch self {
        case .man: return .man
        case .woman: return .woman
        case .other: return .other
        case .none: return .none
        }
    }

    static var defaultGender: ProfileModelObject.Gender = .none

    static func menu(_ value: Int) -> Self {
        .init(rawValue: value) ?? .none
    }
}

// MARK: - stored properties & init

final class ProfileMenuInputView: UIView {
    @Published private(set) var selectedType: ProfileMenuGenderType = .none

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .axis(.vertical)
        ]
    )

    private lazy var arrangedSubviews = [
        titleView,
        buttonInputView
    ]

    private lazy var titleView = UIView(
        styles: [
            .addSubview(titleLabel),
            .backgroundColor(.thinGray),
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4)
        ]
    )

    private lazy var buttonInputView = UIView(
        styles: [
            .addSubview(menuButton),
            .backgroundColor(.primary)
        ]
    )

    private let titleLabel = UILabel(
        styles: [
            .boldSystemFont(size: 16),
            .textColor(.secondary)
        ]
    )

    private let menuButton = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .contentEdgeInsets(.left, 8),
            .contentHorizontalAlignment(.leading),
            .cornerRadius(4),
            .setTitleColor(.theme),
            .systemFont(size: 17)
        ]
    )

    init(title: String) {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        setupMenu()

        titleLabel.apply(.text(title))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, menuButton].forEach {
                $0.apply(.borderColor(.theme))
            }
        }
    }
}

// MARK: - private methods

private extension ProfileMenuInputView {
    func setupViews() {
        apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        titleView.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        buttonInputView.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        menuButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }

    func setupMenu() {
        var actions = [UIMenuElement]()

        ProfileMenuGenderType.allCases.forEach { type in
            actions.append(
                UIAction(
                    title: type.title,
                    state: type == selectedType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedType = type
                        self?.setupMenu()
                    }
                )
            )
        }

        menuButton.apply([
            .menu(.init(
                title: "",
                options: .displayInline,
                children: actions
            )),
            .setTitle(selectedType.title),
            .showsMenuAsPrimaryAction(true)
        ])
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileMenuInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfileMenuInputView(
                    title: "title"
                )
            )
        }
    }
#endif
