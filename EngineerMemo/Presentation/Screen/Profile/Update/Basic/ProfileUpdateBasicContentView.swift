import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateBasicContentView: UIView {
    private(set) lazy var didChangeNameInputPublisher = nameInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeBirthdayInputPublisher = birthdayInputView.didChangeInputDatePublisher
    private(set) lazy var didChangeGenderInputPublisher = genderInputView.$selectedGenderType
    private(set) lazy var didChangeEmailInputPublisher = emailInputView.didChangeInputTextPublisher
    private(set) lazy var didChangePhoneNumberInputPublisher = phoneNumberInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeAddressInputPublisher = addressInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeStationInputPublisher = stationInputView.didChangeInputTextPublisher
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
        nameInputView
        birthdayInputView
        genderInputView
        emailInputView
        phoneNumberInputView
        addressInputView
        stationInputView
    }

    private let nameInputView = ProfileUpdateBasicTextInputView(.name)
    private let birthdayInputView = ProfileUpdateBasicBirthdayInputView()
    private let genderInputView = ProfileUpdateBasicGenderInputView()
    private let emailInputView = ProfileUpdateBasicTextInputView(.email)
    private let phoneNumberInputView = ProfileUpdateBasicTextInputView(.phoneNumber)
    private let addressInputView = ProfileUpdateBasicTextInputView(.address)
    private let stationInputView = ProfileUpdateBasicTextInputView(.station)

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: ProfileModelObject?

    init(modelObject: ProfileModelObject?) {
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

extension ProfileUpdateBasicContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension ProfileUpdateBasicContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func setupValue() {
        nameInputView.updateValue(.name, modelObject: modelObject)
        birthdayInputView.updateValue(modelObject: modelObject)
        genderInputView.updateValue(modelObject: modelObject)
        emailInputView.updateValue(.email, modelObject: modelObject)
        phoneNumberInputView.updateValue(.phoneNumber, modelObject: modelObject)
        addressInputView.updateValue(.address, modelObject: modelObject)
        stationInputView.updateValue(.station, modelObject: modelObject)
    }

    func setupBarButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject.isNil
            ? .settingNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject.isNil
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

extension ProfileUpdateBasicContentView: ContentView {
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

    struct ProfileUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateBasicContentView(modelObject: nil))
        }
    }
#endif
