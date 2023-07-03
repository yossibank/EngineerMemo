import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class BasicUpdateContentView: UIView {
    private(set) lazy var didChangeNameInputPublisher = nameInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeBirthdayInputPublisher = birthdayInputView.didChangeInputDatePublisher
    private(set) lazy var didChangeGenderInputPublisher = genderInputView.$selectedGenderType
    private(set) lazy var didChangeEmailInputPublisher = emailInputView.didChangeInputTextPublisher
    private(set) lazy var didChangePhoneNumberInputPublisher = phoneNumberInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeAddressInputPublisher = addressInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeStationInputPublisher = stationInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(80)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(
        distribution: .equalSpacing,
        spacing: 16
    ) {
        nameInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.name,
                icon: Asset.myName.image,
                placeholder: L10n.Profile.Example.name
            ))

            $0.updateValue(modelObject?.name?.notNoSettingText)
        }

        birthdayInputView.configure {
            $0.updateValue(modelObject: modelObject)
        }

        genderInputView.configure {
            $0.updateValue(modelObject)
        }

        emailInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.email,
                icon: Asset.email.image,
                placeholder: L10n.Profile.Example.email,
                keyboardType: .emailAddress
            ))

            $0.updateValue(modelObject?.email?.notNoSettingText)
        }

        phoneNumberInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.phoneNumber,
                icon: Asset.phoneNumber.image,
                placeholder: L10n.Profile.Example.phoneNumber,
                keyboardType: .numberPad
            ))

            $0.updateValue(modelObject?.phoneNumber?.notNoSettingText)
        }

        addressInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.address,
                icon: Asset.address.image,
                placeholder: L10n.Profile.Example.address
            ))

            $0.updateValue(modelObject?.address?.notNoSettingText)
        }

        stationInputView.configure {
            $0.inputValue(.init(
                title: L10n.Profile.station,
                icon: Asset.station.image,
                placeholder: L10n.Profile.Example.station
            ))

            $0.updateValue(modelObject?.station?.notNoSettingText)
        }
    }

    private let nameInputView = UpdateTextInputView()
    private let birthdayInputView = UpdatePickerInputView()
    private let genderInputView = UpdateMenuInputView(.gender)
    private let emailInputView = UpdateTextInputView()
    private let phoneNumberInputView = UpdateTextInputView()
    private let addressInputView = UpdateTextInputView()
    private let stationInputView = UpdateTextInputView()

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: ProfileModelObject?

    init(modelObject: ProfileModelObject?) {
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

extension BasicUpdateContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension BasicUpdateContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
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

extension BasicUpdateContentView: ContentView {
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

    struct BasicUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: BasicUpdateContentView(modelObject: nil))
        }
    }
#endif
