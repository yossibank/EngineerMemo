import Combine
import UIKit
import UIKitHelper

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
        case .none: return .noSetting
        }
    }

    static var defaultGender: ProfileModelObject.Gender = .noSetting

    static func menu(_ value: Int) -> Self {
        .init(rawValue: value) ?? .none
    }
}

// MARK: - properties & init

final class ProfileMenuInputView: UIView {
    @Published private(set) var selectedType: ProfileMenuGenderType = .none

    private var body: UIView {
        VStackView {
            titleView
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)
                .modifier(\.backgroundColor, .thinGray)

            buttonInputView
        }
    }

    private lazy var titleView = UIView()
        .addSubview(titleLabel) {
            $0.edges.equalToSuperview().inset(8)
        }
        .addConstraint {
            $0.height.equalTo(40)
        }

    private lazy var buttonInputView = UIView()
        .addSubview(menuButton) {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }
        .addConstraint {
            $0.height.equalTo(80)
        }

    private let titleLabel = UILabel()
        .modifier(\.textColor, .secondary)
        .modifier(\.font, .boldSystemFont(ofSize: 16))

    private let menuButton = UIButton(type: .system)
        .modifier(\.layer.borderColor, UIColor.theme.cgColor)
        .modifier(\.layer.borderWidth, 1.0)
        .modifier(\.layer.cornerRadius, 4)
        .modifier(\.clipsToBounds, true)
        .modifier(\.contentHorizontalAlignment, .leading)
        .modifier(\.contentEdgeInsets, .init(.left, 8))
        .configure {
            $0.titleLabel?.font = .systemFont(ofSize: 17)
            $0.setTitleColor(.theme, for: .normal)
        }

    init(title: String) {
        super.init(frame: .zero)

        setupView()
        setupMenu()

        titleLabel.text = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, menuButton].forEach {
                $0.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }
}

// MARK: - internal methods

extension ProfileMenuInputView {
    func updateValue(modelObject: ProfileModelObject?) {
        guard
            let modelObject,
            let gender = modelObject.gender
        else {
            return
        }

        selectedType = .init(rawValue: gender.rawValue) ?? .none
        setupMenu()
    }
}

// MARK: - private methods

private extension ProfileMenuInputView {
    func setupView() {
        backgroundColor = .primary

        addSubview(body) {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
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

        menuButton.configure {
            $0.menu = .init(
                title: "",
                options: .displayInline,
                children: actions
            )
            $0.setTitle(selectedType.title, for: .normal)
            $0.showsMenuAsPrimaryAction = true
        }
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
