import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateSkillContentView: UIView {
    private(set) lazy var didChangeCareerInputPublisher = careerInputView.$selectedCareerType
    private(set) lazy var didChangeLanguageCareerInputPublisher = useLanguageInputView.$selectedCareerType
    private(set) lazy var didChangeLanguageInputPublisher = useLanguageInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeToeicScoreInputPublisher = toeicInputView.didChangeInputScorePublisher
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
        careerInputView
        useLanguageInputView
        toeicInputView
    }

    private let careerInputView = ProfileUpdateCareerInputView()
    private let useLanguageInputView = ProfileUpdateUseLanguageInputView()
    private let toeicInputView = ProfileUpdateToeicInputView()

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: ProfileModelObject

    init(modelObject: ProfileModelObject) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
        setupValue()
        setupBarButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfileUpdateSkillContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension ProfileUpdateSkillContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func setupValue() {
        careerInputView.updateValue(modelObject: modelObject.skill)
        useLanguageInputView.updateValue(modelObject: modelObject.skill)
        toeicInputView.updateValue(modelObject: modelObject.skill)
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

extension ProfileUpdateSkillContentView: ContentView {
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

    struct ProfileSkillUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfileUpdateSkillContentView(
                    modelObject: ProfileModelObjectBuilder().build()
                )
            )
        }
    }
#endif
