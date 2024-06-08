import Combine
import UIKit

// MARK: - properties & init

final class UpdatePickerInputView: UIView {
    private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher

    private var body: UIView {
        VStackView(spacing: 8) {
            UpdateTitleView().configure {
                $0.setTitle(
                    title: L10n.Profile.birthday,
                    icon: Asset.birthday.image
                )
            }

            VStackView(spacing: 4) {
                UIView()
                    .addSubview(inputDatePicker) {
                        $0.edges.equalToSuperview()
                    }
                    .addSubview(pickerLabel) {
                        $0.verticalEdges.equalToSuperview()
                        $0.horizontalEdges.equalToSuperview().inset(8)
                    }
                    .addConstraint {
                        $0.height.equalTo(40)
                    }

                borderView
            }
        }
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

extension UpdatePickerInputView {
    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: inputDatePicker)
    }
}

// MARK: - internal methods

extension UpdatePickerInputView {
    func setPickerValue(modelObject: ProfileModelObject?) {
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

private extension UpdatePickerInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }

    func setupPicker() {
        inputDatePicker.expandPickerRange()

        cancellables.formUnion([
            inputDatePicker.publisher(for: .editingDidBegin).weakSink(with: self) {
                $0.borderView.changeColor(.inputBorder)
            },
            inputDatePicker.publisher(for: .editingDidEnd).weakSink(with: self) {
                $0.borderView.changeColor(.primary)
            },
            inputDatePicker.publisher.weakSink(with: self) {
                $0.pickerLabel.text = $1.toString
            }
        ])
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct BasicUpdateBirthdayInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UpdatePickerInputView())
                .frame(height: 110)
        }
    }
#endif
