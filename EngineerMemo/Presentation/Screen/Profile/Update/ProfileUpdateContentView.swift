import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class ProfileUpdateContentView: UIView {
    private lazy var scrollView: UIScrollView = {
        $0.addSubview(stackView)
        return $0
    }(UIScrollView())

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(arrangedSubviews: [
        nameInputView,
        birthdayInputView,
        genderInputView,
        emailInputView,
        phoneNumberInputView,
        stationInputView
    ]))

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

    private let stationInputView: ProfileTextInputView = {
        $0.configure(title: L10n.Profile.station)
        $0.placeholder(L10n.Profile.Example.station)
        return $0
    }(ProfileTextInputView())

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
