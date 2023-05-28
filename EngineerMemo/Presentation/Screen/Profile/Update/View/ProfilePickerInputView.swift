import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfilePickerInputView: UIView {
    private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView
                .addSubview(titleLabel) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)

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

    private let titleView = UIView()

    private let titleLabel = UILabel().configure {
        $0.textColor = .secondaryGray
        $0.font = .boldSystemFont(ofSize: 16)
    }

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

    private var cancellables: Set<AnyCancellable> = .init()

    init(title: String) {
        super.init(frame: .zero)

        setupView(title: title)
        setupPicker()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfilePickerInputView {
    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: inputDatePicker)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            titleView.layer.borderColor = UIColor.primary.cgColor
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
    func setupView(title: String) {
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }

        titleLabel.text = title
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

    struct ProfilePickerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfilePickerInputView(title: "title"))
        }
    }
#endif
