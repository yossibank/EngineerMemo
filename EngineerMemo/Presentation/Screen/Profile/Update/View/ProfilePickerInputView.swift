import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfilePickerInputView: UIView {
    private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher

    private var body: UIView {
        VStackView {
            titleView
                .addSubview(titleLabel) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)

            pickerInputView
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
        }
    }

    private let titleView = UIView()
    private let pickerInputView = UIView()

    private let titleLabel = UILabel().configure {
        $0.textColor = .secondary
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let inputDatePicker = UIDatePicker().configure {
        $0.clipsToBounds = true
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.locale = .japan
        $0.preferredDatePickerStyle = .compact
        $0.layer.borderColor = UIColor.theme.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 4
    }

    private let pickerLabel = UILabel().configure {
        $0.text = .noSetting
    }

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
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .primary
        }
    }

    func setupPicker() {
        inputDatePicker.expandPickerRange()
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
