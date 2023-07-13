import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class SkillUpdateLanguageInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    @Published private(set) var selectedCareerType: SkillCareerType = .noSetting

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.setTitle(
                    title: L10n.Profile.useLanguage,
                    icon: Asset.language.image
                )
            }

            VStackView(spacing: 4) {
                HStackView {
                    inputTextField
                        .configure {
                            $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 0))
                            $0.leftViewMode = .always
                            $0.placeholder = L10n.Profile.Example.useLanguage
                            $0.delegate = self
                        }

                    menuButton.addConstraint {
                        $0.width.equalTo(80)
                    }

                    UIView().addConstraint {
                        $0.width.equalTo(16)
                    }
                }

                borderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }
    }

    private let titleView = UpdateTitleView()
    private let inputTextField = UITextField()
    private let menuButton = MenuButton(type: .system)
    private let borderView = BorderView()

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupMenu()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension SkillUpdateLanguageInputView {
    func setLanguageValue(modelObject: SkillModelObject?) {
        guard let modelObject else {
            return
        }

        if let languageCareer = modelObject.languageCareer {
            selectedCareerType = .init(rawValue: languageCareer) ?? .noSetting
            setupMenu()
        }

        inputTextField.text = modelObject.language
    }
}

// MARK: - private methods

private extension SkillUpdateLanguageInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }

    func setupMenu() {
        var actions = [UIMenuElement]()

        SkillCareerType.allCases.forEach { careerType in
            actions.append(
                UIAction(
                    title: careerType.title,
                    state: careerType == selectedCareerType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedCareerType = careerType
                        self?.setupMenu()
                    }
                )
            )
        }

        menuButton.configure {
            var config = UIButton.Configuration.filled()
            config.title = selectedCareerType.title
            config.baseForegroundColor = .primary
            config.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 16)
                return outgoing
            }
            config.background.backgroundColor = .background
            $0.configuration = config
            $0.contentHorizontalAlignment = .trailing
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

// MARK: - delegate

extension SkillUpdateLanguageInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderView.changeColor(.inputBorder)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        borderView.changeColor(.primary)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SkillUpdateLanguageInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SkillUpdateLanguageInputView())
        }
    }
#endif
