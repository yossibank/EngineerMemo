import Combine
import SnapKit
import UIKit

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

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [
        titleView,
        buttonInputView
    ]))

    private lazy var titleView: UIView = {
        $0.addSubview(titleLabel)
        return $0
    }(UIView(
        styles: [
            .backgroundLightGray,
            .borderPrimary,
            .cornerRadius4
        ]
    ))

    private lazy var buttonInputView: UIView = {
        $0.addSubview(menuButton)
        return $0
    }(UIView(style: .backgroundPrimary))

    private let titleLabel = UILabel(
        styles: [
            .bold16,
            .textSecondary
        ]
    )

    private let menuButton: UIButton = {
        $0.titleEdgeInsets.left = 8
        return $0
    }(UIButton(
        styles: [
            .system17,
            .titlePrimary,
            .titleLeft,
            .borderPrimary,
            .cornerRadius4
        ]
    ))

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupMenu()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, menuButton].forEach {
                $0.apply(.borderPrimary)
            }
        }
    }
}

// MARK: - internal methods

extension ProfileMenuInputView {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - private methods

private extension ProfileMenuInputView {
    func setupViews() {
        apply(.backgroundPrimary)
        addSubview(stackView)
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

        menuButton.menu = .init(
            title: "",
            options: .displayInline,
            children: actions
        )
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.setTitle(selectedType.title, for: .normal)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileMenuInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileMenuInputView()) {
                $0.configure(title: "title")
            }
        }
    }
#endif