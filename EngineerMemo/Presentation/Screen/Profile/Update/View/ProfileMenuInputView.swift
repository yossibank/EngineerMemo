import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileMenuInputView: UIView {
    @Published private(set) var selectedGenderType: ProfileGenderType = .noSetting

    private var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView
                .addSubview(titleStackView) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)

            VStackView(spacing: 4) {
                menuButton
                borderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }
    }

    private lazy var titleStackView = HStackView(spacing: 4) {
        titleIconImageView
            .addConstraint {
                $0.size.equalTo(24)
            }
            .configure {
                $0.image = Asset.profileGender.image
            }

        titleLabel.configure {
            $0.textColor = .secondaryGray
            $0.font = .boldSystemFont(ofSize: 16)
        }

        UIView()
    }

    private let titleView = UIView()
    private let titleIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let menuButton = MenuButton(type: .system)
    private let borderView = BorderView()

    init(title: String) {
        super.init(frame: .zero)

        setupView(title: title)
        setupMenu()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfileMenuInputView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            titleView.layer.borderColor = UIColor.primary.cgColor
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

        selectedGenderType = .init(rawValue: gender.rawValue) ?? .noSetting
        setupMenu()
    }
}

// MARK: - private methods

private extension ProfileMenuInputView {
    func setupView(title: String) {
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }

        titleLabel.text = title
    }

    func setupMenu() {
        var actions = [UIMenuElement]()

        ProfileGenderType.allCases.forEach { genderType in
            actions.append(
                UIAction(
                    title: genderType.title,
                    state: genderType == selectedGenderType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedGenderType = genderType
                        self?.setupMenu()
                    }
                )
            )
        }

        menuButton.configure {
            var config = UIButton.Configuration.filled()
            config.title = selectedGenderType.title
            config.baseForegroundColor = .primary
            config.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 16)
                return outgoing
            }
            config.background.backgroundColor = .background
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
            $0.showsMenuAsPrimaryAction = true
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
        }

        menuButton.$isShowMenu.sink { [weak self] isShow in
            self?.borderView.changeColor(isShow ? .inputBorder : .primary)
        }
        .store(in: &cancellables)
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
