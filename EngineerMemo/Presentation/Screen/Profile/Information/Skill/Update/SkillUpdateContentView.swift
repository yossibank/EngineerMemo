import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class SkillUpdateContentView: UIView {
    private(set) lazy var didChangeCareerInputPublisher = careerInputView.$selectedCareerType
    private(set) lazy var didChangeLanguageCareerInputPublisher = useLanguageInputView.$selectedCareerType
    private(set) lazy var didChangeLanguageInputPublisher = useLanguageInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeToeicScoreInputPublisher = toeicInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(
        distribution: .equalSpacing,
        spacing: 16
    ) {
        careerInputView.configure {
            $0.updateValue(modelObject.skill)
        }

        useLanguageInputView.configure {
            $0.updateValue(modelObject: modelObject.skill)
        }

        toeicInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.toeic,
                icon: Asset.toeic.image,
                placeholder: L10n.Profile.Example.toeic,
                keyboardType: .numberPad
            ))

            $0.updateValue(modelObject.skill?.toeic?.description)
        }
    }

    private let careerInputView = UpdateMenuInputView(.career)
    private let useLanguageInputView = SkillUpdateLanguageInputView()
    private let toeicInputView = UpdateTextInputView()

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: ProfileModelObject

    init(modelObject: ProfileModelObject) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
        setupBarButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension SkillUpdateContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension SkillUpdateContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func setupBarButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject.skill.isNil
            ? .settingNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject.skill.isNil
            ? .settingDoneNavigationButton
            : .updateDoneNavigationButton

        barButton.apply(defaultButtonStyle)

        barButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.barButton.apply(updatedButtonStyle)

                Task { @MainActor in
                    try await Task.sleep(seconds: 0.8)
                    self?.barButton.apply(defaultButtonStyle)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - protocol

extension SkillUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.bottom.equalToSuperview().priority(.low)
                $0.horizontalEdges.equalToSuperview()
            }

            $0.keyboardLayoutGuide.snp.makeConstraints {
                $0.top.equalTo(scrollView.snp.bottom).inset(-16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SkillUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: SkillUpdateContentView(
                    modelObject: ProfileModelObjectBuilder().build()
                )
            )
        }
    }
#endif
