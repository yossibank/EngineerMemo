import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class SkillUpdateCareerInputView: UIView {
    @Published private(set) var selectedCareerType: SkillCareerType = .noSetting

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.configure(
                    title: L10n.Profile.engineerCareer,
                    icon: Asset.engineerCareer.image
                )
            }

            VStackView(spacing: 4) {
                menuButton
                borderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }
    }

    private let titleView = UpdateTitleView()
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

extension SkillUpdateCareerInputView {
    func updateValue(modelObject: SkillModelObject?) {
        guard
            let modelObject,
            let engineerCareer = modelObject.engineerCareer
        else {
            return
        }

        selectedCareerType = .init(rawValue: engineerCareer) ?? .noSetting
        setupMenu()
    }
}

// MARK: - private methods

private extension SkillUpdateCareerInputView {
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

    struct SkillUpdateCareerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SkillUpdateCareerInputView())
        }
    }
#endif
