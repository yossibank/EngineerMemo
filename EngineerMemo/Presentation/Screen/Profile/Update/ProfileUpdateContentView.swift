import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfileUpdateContentView: UIView {
    private(set) lazy var nameInputPublisher = nameInputView.inputPublisher
    private(set) lazy var birthdayInputPublisher = birthdayInputView.inputPublisher
    private(set) lazy var genderInputPublisher = genderInputView.$selectedType
    private(set) lazy var emailInputPublisher = emailInputView.inputPublisher
    private(set) lazy var phoneNumberInputPublisher = phoneNumberInputView.inputPublisher
    private(set) lazy var addressInputPublisher = addressInputView.inputPublisher
    private(set) lazy var stationInputPublisher = stationInputView.inputPublisher
    private(set) lazy var didTapSaveButtonPublisher = saveButton.publisher(for: .touchUpInside)

    private lazy var scrollView = UIScrollView(
        style: .addSubview(stackView)
    )

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .alignment(.fill),
            .axis(.vertical),
            .distribution(.equalSpacing)
        ]
    )

    private lazy var buttonView = UIView(
        style: .addSubview(saveButton)
    )

    private lazy var arrangedSubviews = [
        nameInputView,
        birthdayInputView,
        genderInputView,
        emailInputView,
        phoneNumberInputView,
        addressInputView,
        stationInputView,
        buttonView
    ]

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

    private lazy var saveButton = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(8),
            .setTitle(
                modelObject == nil
                    ? L10n.Components.Button.saveProfile
                    : L10n.Components.Button.updateProfile
            ),
            .setTitleColor(.theme)
        ]
    )

    private var cancellables: Set<AnyCancellable> = .init()

    private let modelObject: ProfileModelObject?

    init(modelObject: ProfileModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        setupEvents()
        setupInitializeValue()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            saveButton.apply(.borderColor(.theme))
        }
    }
}

// MARK: - private

private extension ProfileUpdateContentView {
    func setupEvents() {
        let title = modelObject == nil
            ? L10n.Components.Button.saveProfile
            : L10n.Components.Button.updateProfile

        let updatedTitle = modelObject == nil
            ? L10n.Components.Button.saveProfileDone
            : L10n.Components.Button.updateProfileDone

        didTapSaveButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveButton.apply(.setTitle(updatedTitle))

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.saveButton.apply(.setTitle(title))
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
    func setupViews() {
        apply([
            .addSubview(scrollView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfileUpdateContentView()
            )
        }
    }
#endif
