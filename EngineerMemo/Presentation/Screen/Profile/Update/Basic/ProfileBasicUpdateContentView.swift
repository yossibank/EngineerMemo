import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileBasicUpdateContentView: UIView {
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

    private lazy var body = VStackView(distribution: .equalSpacing, spacing: 16) {
        nameInputView.configure {
            $0.updateValue(.name, modelObject: modelObject)
        }

        birthdayInputView.configure {
            $0.updateValue(modelObject: modelObject)
        }

        genderInputView.configure {
            $0.updateValue(modelObject: modelObject)
        }

        emailInputView.configure {
            $0.updateValue(.email, modelObject: modelObject)
        }

        phoneNumberInputView.configure {
            $0.updateValue(.phoneNumber, modelObject: modelObject)
        }

        addressInputView.configure {
            $0.updateValue(.address, modelObject: modelObject)
        }

        stationInputView.configure {
            $0.updateValue(.station, modelObject: modelObject)
        }
    }

    private var cancellables: Set<AnyCancellable> = .init()

    private let nameInputView = ProfileUpdateTextInputView(.name)
    private let birthdayInputView = ProfileUpdatePickerInputView(title: L10n.Profile.birthday)
    private let genderInputView = ProfileUpdateMenuInputView(title: L10n.Profile.gender)
    private let emailInputView = ProfileUpdateTextInputView(.email)
    private let phoneNumberInputView = ProfileUpdateTextInputView(.phoneNumber)
    private let addressInputView = ProfileUpdateTextInputView(.address)
    private let stationInputView = ProfileUpdateTextInputView(.station)

    private let modelObject: ProfileModelObject?

    init(modelObject: ProfileModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupBarButton()
        setupEvent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfileBasicUpdateContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension ProfileBasicUpdateContentView {
    func setupBarButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .settingNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .settingDoneNavigationButton
            : .updateDoneNavigationButton

        barButton.apply(defaultButtonStyle)

        barButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.barButton.apply(updatedButtonStyle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self?.barButton.apply(defaultButtonStyle)
                }
            }
            .store(in: &cancellables)
    }

    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }
}

// MARK: - protocol

extension ProfileBasicUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.bottom.equalToSuperview().priority(.low)
                $0.leading.trailing.equalToSuperview()
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
            WrapperView(view: ProfileBasicUpdateContentView(modelObject: nil))
        }
    }
#endif
