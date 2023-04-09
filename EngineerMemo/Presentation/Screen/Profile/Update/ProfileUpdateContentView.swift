import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateContentView: UIView {
    private(set) lazy var didChangeNameInputPublisher = nameInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeBirthdayInputPublisher = birthdayInputView.didChangeInputDatePublisher
    private(set) lazy var didChangeGenderInputPublisher = genderInputView.$selectedType
    private(set) lazy var didChangeEmailInputPublisher = emailInputView.didChangeInputTextPublisher
    private(set) lazy var didChangePhoneNumberInputPublisher = phoneNumberInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeAddressInputPublisher = addressInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeStationInputPublisher = stationInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(stackView) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var stackView = VStackView(distribution: .equalSpacing) {
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

    private let nameInputView = ProfileTextInputView(
        title: L10n.Profile.name,
        placeholder: L10n.Profile.Example.name
    )

    private let birthdayInputView = ProfilePickerInputView(
        title: L10n.Profile.birthday
    )

    private let genderInputView = ProfileMenuInputView(
        title: L10n.Profile.gender
    )

    private let emailInputView = ProfileTextInputView(
        title: L10n.Profile.email,
        placeholder: L10n.Profile.Example.email,
        keyboardType: .emailAddress
    )

    private let phoneNumberInputView = ProfileTextInputView(
        title: L10n.Profile.phoneNumber,
        placeholder: L10n.Profile.Example.phoneNumber,
        keyboardType: .numberPad
    )

    private let addressInputView = ProfileTextInputView(
        title: L10n.Profile.address,
        placeholder: L10n.Profile.Example.address
    )

    private let stationInputView = ProfileTextInputView(
        title: L10n.Profile.station,
        placeholder: L10n.Profile.Example.station
    )

    private var cancellables: Set<AnyCancellable> = .init()

    private let modelObject: ProfileModelObject?

    init(modelObject: ProfileModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.theme.cgColor
        }
    }
}

// MARK: - private methods

private extension ProfileUpdateContentView {
    func setupEvent() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .settingButton
            : .updateButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .settingDoneButton
            : .updateDoneButton

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
}

// MARK: - protocol

extension ProfileUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .primary
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateContentView(modelObject: nil))
        }
    }
#endif
