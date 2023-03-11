#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsDateView: UIView {
        private(set) lazy var didChangeInputDatePublisher = inputDatePicker.publisher
        private(set) lazy var didTapNilButtonPublisher = nilButton.publisher(for: .touchUpInside)

        private var cancellables: Set<AnyCancellable> = .init()

        private var body: UIView {
            VStackView(spacing: 32) {
                VStackView(alignment: .center, spacing: 16) {
                    titleLabel
                        .modifier(\.text, L10n.Debug.UserDefaults.value)
                        .modifier(\.font, .boldSystemFont(ofSize: 13))

                    descriptionLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                        .modifier(\.numberOfLines, 0)
                }

                pickerInputView
            }
        }

        private lazy var pickerInputView = UIView()
            .addSubview(inputDatePicker) {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview().inset(32)
            }
            .addSubview(pickerLabel) {
                $0.center.equalToSuperview()
            }
            .addConstraint {
                $0.height.equalTo(80)
            }

        private let titleLabel = UILabel()
        private let descriptionLabel = UILabel()

        private let pickerLabel = UILabel()
            .modifier(\.textAlignment, .center)

        private let inputDatePicker = UIDatePicker()
            .modifier(\.layer.borderColor, UIColor.theme.cgColor)
            .modifier(\.layer.borderWidth, 1.0)
            .modifier(\.layer.cornerRadius, 4)
            .modifier(\.clipsToBounds, true)
            .modifier(\.contentHorizontalAlignment, .center)
            .modifier(\.datePickerMode, .date)
            .modifier(\.locale, .japan)
            .modifier(\.preferredDatePickerStyle, .compact)

        private let nilButton = UIButton(type: .system)
            .apply(.debugNilButton)

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupPicker()
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

                [nilButton, inputDatePicker].forEach {
                    $0.layer.borderColor = UIColor.theme.cgColor
                }
            }
        }
    }

    // MARK: - internal methods

    extension DebugUserDefaultsDateView {
        func configureNilButton(_ isOptional: Bool) {
            nilButton.isHidden = !isOptional
        }

        func updateDescription(_ description: String) {
            descriptionLabel.text = description
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsDateView {
        func setupView() {
            addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }

            addSubview(nilButton) {
                $0.top.trailing.equalToSuperview().inset(8)
                $0.width.equalTo(40)
            }

            configure {
                $0.backgroundColor = .thinGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
        }

        func setupPicker() {
            inputDatePicker.expandPickerRange()
            inputDatePicker.publisher
                .sink { [weak self] date in
                    self?.pickerLabel.text = date.toString
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - preview

    struct DebugUserDefaultsDateViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUserDefaultsDateView()) {
                $0.updateDescription("UserDefaults保存値")
            }
            .frame(height: 200)
        }
    }
#endif
