import Combine
import UIKit

// MARK: - properties & init

final class UpdateMenuInputView: UIView {
    @Published private(set) var selectedGenderType: ProfileGenderType = .noSetting
    @Published private(set) var selectedCareerType: SkillCareerType = .noSetting
    @Published private(set) var selectedCategoryType: MemoInputCategoryType = .noSetting

    private var body: UIView {
        VStackView(spacing: 8) {
            titleView

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

    private let menuInput: UpdateMenuInput

    init(_ menuInput: UpdateMenuInput) {
        self.menuInput = menuInput

        super.init(frame: .zero)

        setupView()
        setupMenu()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension UpdateMenuInputView {
    func setGenderMenu(_ modelObject: ProfileModelObject?) {
        guard
            let modelObject,
            let gender = modelObject.gender
        else {
            return
        }

        selectedGenderType = .init(rawValue: gender.rawValue) ?? .noSetting
        setupMenu()
    }

    func setCareerMenu(_ modelObject: SkillModelObject?) {
        guard
            let modelObject,
            let engineerCareer = modelObject.engineerCareer
        else {
            return
        }

        selectedCareerType = .init(rawValue: engineerCareer) ?? .noSetting
        setupMenu()
    }

    func setCategoryMenu(_ modelObject: MemoModelObject?) {
        guard let category = modelObject?.category else {
            selectedCategoryType = .noSetting
            return
        }

        switch category {
        case .todo:
            selectedCategoryType = .todo

        case .technical:
            selectedCategoryType = .technical

        case .interview:
            selectedCategoryType = .interview

        case .event:
            selectedCategoryType = .event

        case .tax:
            selectedCategoryType = .tax

        case .other:
            selectedCategoryType = .other

        case .widget:
            selectedCategoryType = .widget
        }

        setupMenu()
    }
}

// MARK: - private methods

private extension UpdateMenuInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }

        switch menuInput {
        case .gender:
            titleView.setTitle(
                title: L10n.Profile.gender,
                icon: Asset.gender.image
            )

        case .career:
            titleView.setTitle(
                title: L10n.Profile.engineerCareer,
                icon: Asset.engineerCareer.image
            )

        case .category:
            titleView.setTitle(
                title: L10n.Memo.category,
                icon: Asset.memoCategory.image
            )
        }
    }

    func setupMenu() {
        var actions = [UIMenuElement]()

        switch menuInput {
        case .gender:
            for genderType in ProfileGenderType.allCases {
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

            menuButton.apply(
                .menuButton(
                    title: selectedGenderType.title,
                    actions: actions
                )
            )

        case .career:
            for careerType in SkillCareerType.allCases {
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

            menuButton.apply(
                .menuButton(
                    title: selectedCareerType.title,
                    actions: actions
                )
            )

        case .category:
            for categoryType in MemoInputCategoryType.allCases {
                actions.append(
                    UIAction(
                        title: categoryType.title,
                        image: categoryType.image,
                        state: categoryType == selectedCategoryType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedCategoryType = categoryType
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.apply(
                .menuButton(
                    title: selectedCategoryType.title,
                    icon: selectedCategoryType.image,
                    actions: actions
                )
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

    struct BasicUpdateGenderInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UpdateMenuInputView(.gender))
                .frame(height: 100)
        }
    }
#endif
