import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfilePickerInputView: UIView {
    private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher

    private var body: UIView {
        VStackView {
            titleView
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)
                .modifier(\.backgroundColor, .thinGray)

            pickerInputView
        }
    }

    private lazy var titleView = UIView()
        .addSubview(titleLabel) {
            $0.edges.equalToSuperview().inset(8)
        }
        .addConstraint {
            $0.height.equalTo(40)
        }

    private lazy var pickerInputView = UIView()
        .addSubview(inputDatePicker) {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }
        .addSubview(pickerLabel) {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview()
        }
        .addConstraint {
            $0.height.equalTo(80)
        }

    private let titleLabel = UILabel()
        .modifier(\.textColor, .secondary)
        .modifier(\.font, .boldSystemFont(ofSize: 16))

    private let inputDatePicker = UIDatePicker()
        .modifier(\.layer.borderColor, UIColor.theme.cgColor)
        .modifier(\.layer.borderWidth, 1.0)
        .modifier(\.layer.cornerRadius, 4)
        .modifier(\.clipsToBounds, true)
        .modifier(\.contentHorizontalAlignment, .leading)
        .modifier(\.datePickerMode, .date)
        .modifier(\.locale, .japan)
        .modifier(\.preferredDatePickerStyle, .compact)

    private let pickerLabel = UILabel()
        .modifier(\.text, .noSetting)

    private var cancellables: Set<AnyCancellable> = .init()

    init(title: String) {
        super.init(frame: .zero)

        setupView()
        setupPicker()

        titleLabel.text = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: inputDatePicker)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, inputDatePicker].forEach {
                $0.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }
}

// MARK: - internal methods

extension ProfilePickerInputView {
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

private extension ProfilePickerInputView {
    func setupView() {
        backgroundColor = .primary

        addSubview(body) {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func setupPicker() {
        inputDatePicker.expandPickerRange()
        inputDatePicker.publisher
            .sink { [weak self] birthday in
                self?.pickerLabel.text = birthday.toString
            }
            .store(in: &cancellables)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfilePickerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfilePickerInputView(
                    title: "title"
                )
            )
        }
    }
#endif
