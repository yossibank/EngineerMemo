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
                .addSubview(titleLabel) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)

            buttonInputView
                .addSubview(menuButton) {
                    $0.top.bottom.equalToSuperview().inset(16)
                    $0.leading.trailing.equalToSuperview()
                }
                .addConstraint {
                    $0.height.equalTo(80)
                }
        }
    }

    private let titleView = UIView()
    private let buttonInputView = UIView()

    private let titleLabel = UILabel().configure {
        $0.textColor = .secondaryGray
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let menuButton = UIButton(type: .system).configure {
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17)
        $0.contentHorizontalAlignment = .leading
        $0.contentEdgeInsets = .init(.left, 8)
        $0.layer.borderColor = UIColor.primary.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
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
                $0.layer.borderColor = UIColor.primary.cgColor
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
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
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
                title: .empty,
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
            WrapperView(view: ProfileMenuInputView(title: "title"))
        }
    }
#endif
