import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateBirthdayInputView: UIView {
    private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.configure(
                    title: L10n.Profile.birthday,
                    icon: Asset.profileBirthday.image
                )
            }

            VStackView(spacing: 4) {
                UIView()
                    .addSubview(inputDatePicker) {
                        $0.edges.equalToSuperview()
                    }
                    .addSubview(pickerLabel) {
                        $0.top.bottom.equalToSuperview()
                        $0.leading.trailing.equalToSuperview().inset(8)
                    }
                    .addConstraint {
                        $0.height.equalTo(40)
                    }

                borderView
            }
        }
    }

    private let titleView = ProfileUpdateTitleView()

    private let inputDatePicker = UIDatePicker().configure {
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.locale = .japan
        $0.preferredDatePickerStyle = .compact
    }

    private let pickerLabel = UILabel().configure {
        $0.text = .noSetting
    }

    private let borderView = BorderView()

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupPicker()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfileUpdateBirthdayInputView {
    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: inputDatePicker)
    }
}

// MARK: - internal methods

extension ProfileUpdateBirthdayInputView {
    func updateValue(modelObject: ProfileModelObject?) {
        guard
            let modelObject,
            let birthday = modelObject.birthday
        else {
            return
        }

        pickerLabel.text = birthday.toString
    }
}

// MARK: - private methods

private extension ProfileUpdateBirthdayInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }

    func setupPicker() {
        inputDatePicker.expandPickerRange()

        inputDatePicker.publisher(for: .editingDidBegin).sink { [weak self] _ in
            self?.borderView.changeColor(.inputBorder)
        }
        .store(in: &cancellables)

        inputDatePicker.publisher(for: .editingDidEnd).sink { [weak self] _ in
            self?.borderView.changeColor(.primary)
        }
        .store(in: &cancellables)

        inputDatePicker.publisher.sink { [weak self] birthday in
            self?.pickerLabel.text = birthday.toString
        }
        .store(in: &cancellables)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileUpdatePickerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateBirthdayInputView())
        }
    }
#endif
