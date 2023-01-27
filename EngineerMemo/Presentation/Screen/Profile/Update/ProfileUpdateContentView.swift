import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class ProfileUpdateContentView: UIView {
    private(set) lazy var nameInputPublisher = nameInputView.inputPublisher
    private(set) lazy var birthdayInputPublisher = birthdayInputView.inputPublisher
    private(set) lazy var genderInputPublisher = genderInputView.$selectedType
    private(set) lazy var emailInputPublisher = emailInputView.inputPublisher
    private(set) lazy var phoneNumberInputPublisher = phoneNumberInputView.inputPublisher
    private(set) lazy var addressInputPublisher = addressInputView.inputPublisher
    private(set) lazy var stationInputPublisher = stationInputView.inputPublisher
    private(set) lazy var didTapSaveButtonPublisher = saveButton.publisher(for: .touchUpInside)

    private lazy var scrollView: UIScrollView = {
        $0.addSubview(stackView)
        return $0
    }(UIScrollView())

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [
        nameInputView,
        birthdayInputView,
        genderInputView,
        emailInputView,
        phoneNumberInputView,
        addressInputView,
        stationInputView,
        buttonView
    ]))

    private lazy var buttonView: UIView = {
        $0.addSubview(saveButton)
        return $0
    }(UIView())

    private let nameInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.name)
        $0.placeholder(L10n.Profile.Example.name)
        return $0
    }(ProfileTextInputView())

    private let birthdayInputView: ProfilePickerInputView = {
        $0.configure(title: L10n.Profile.birthday)
        return $0
    }(ProfilePickerInputView())

    private let genderInputView: ProfileMenuInputView = {
        $0.configure(title: L10n.Profile.gender)
        return $0
    }(ProfileMenuInputView())

    private let emailInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.email, keyboardType: .emailAddress)
        $0.placeholder(L10n.Profile.Example.email)
        return $0
    }(ProfileTextInputView())

    private let phoneNumberInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.phoneNumber)
        $0.placeholder(L10n.Profile.Example.phoneNumber)
        $0.phoneNumber()
        return $0
    }(ProfileTextInputView())

    private let addressInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.address)
        $0.placeholder(L10n.Profile.Example.address)
        return $0
    }(ProfileTextInputView())

    private let stationInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.station)
        $0.placeholder(L10n.Profile.Example.station)
        return $0
    }(ProfileTextInputView())

    private let saveButton = UIButton(
        styles: [
            .ButtonTitle.saveProfile,
            .titlePrimary,
            .borderPrimary,
            .cornerRadius8
        ]
    )

    private var cancellables: Set<AnyCancellable> = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            saveButton.apply(.borderPrimary)
        }
    }
}

// MARK: - protocol

extension ProfileUpdateContentView: ContentView {
    func setupViews() {
        apply(.backgroundPrimary)
        addSubview(scrollView)
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
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
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
