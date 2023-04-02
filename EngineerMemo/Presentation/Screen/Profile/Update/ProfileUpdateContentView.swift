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
    private(set) lazy var didTapSaveButtonPublisher = saveButton.publisher(for: .touchUpInside)

    private lazy var scrollView = UIScrollView().addSubview(stackView) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var stackView = VStackView(distribution: .equalSpacing) {
        nameInputView
        birthdayInputView
        genderInputView
        emailInputView
        phoneNumberInputView
        addressInputView
        stationInputView
        buttonView
    }

    private lazy var buttonView = UIView().addSubview(saveButton) {
        $0.bottom.equalToSuperview().inset(32)
        $0.top.leading.trailing.equalToSuperview().inset(16)
        $0.height.equalTo(60)
    }

    private lazy var saveButton = UIButton(type: .system).configure {
        $0.setTitle(
            modelObject == nil
                ? L10n.Components.Button.saveProfile
                : L10n.Components.Button.updateProfile,
            for: .normal
        )
        $0.setTitleColor(
            .theme,
            for: .normal
        )
        $0.clipsToBounds = true
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.layer.borderColor = UIColor.theme.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 8
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
        setupInitializeValue()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            saveButton.layer.borderColor = UIColor.theme.cgColor
        }
    }
}

// MARK: - private

private extension ProfileUpdateContentView {
    func setupEvent() {
        let title = modelObject == nil
            ? L10n.Components.Button.saveProfile
            : L10n.Components.Button.updateProfile

        let updatedTitle = modelObject == nil
            ? L10n.Components.Button.saveProfileDone
            : L10n.Components.Button.updateProfileDone

        didTapSaveButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveButton.setTitle(updatedTitle, for: .normal)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.saveButton.setTitle(title, for: .normal)
                }
            }
            .store(in: &cancellables)
    }

    func setupInitializeValue() {
        nameInputView.updateValue(.name, modelObject: modelObject)
        birthdayInputView.updateValue(modelObject: modelObject)
        genderInputView.updateValue(modelObject: modelObject)
        emailInputView.updateValue(.email, modelObject: modelObject)
        phoneNumberInputView.updateValue(.phoneNumber, modelObject: modelObject)
        addressInputView.updateValue(.address, modelObject: modelObject)
        stationInputView.updateValue(.station, modelObject: modelObject)
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
