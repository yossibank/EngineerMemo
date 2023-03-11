#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsArrayView: UIView {
        private(set) lazy var didTapAddButtonPublisher = didTapAddButtonSubject.eraseToAnyPublisher()
        private(set) lazy var didTapDeleteButtonPublisher = didTapDeleteButtonSubject.eraseToAnyPublisher()

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

                inputTextField
                    .modifier(\.textAlignment, .center)

                VStackView(alignment: .center) {
                    HStackView(spacing: 16) {
                        addButton
                            .apply(.debugAddButton)

                        deleteButton
                            .apply(.debugDeleteButton)
                    }
                }
            }
        }

        private let titleLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let inputTextField = UnderlinedTextField(color: .theme)

        private let addButton = UIButton(type: .system)
            .addConstraint {
                $0.width.equalTo(100)
            }

        private let deleteButton = UIButton(type: .system)
            .addConstraint {
                $0.width.equalTo(100)
            }

        private let didTapAddButtonSubject = PassthroughSubject<String, Never>()
        private let didTapDeleteButtonSubject = PassthroughSubject<String, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupEvent()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                [addButton, deleteButton].forEach {
                    $0.layer.borderColor = UIColor.theme.cgColor
                }
            }
        }
    }

    // MARK: - internal methods

    extension DebugUserDefaultsArrayView {
        func updateDescription(_ description: String) {
            descriptionLabel.text = description
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsArrayView {
        func setupView() {
            addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }

            configure {
                $0.backgroundColor = .thinGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
        }

        func setupEvent() {
            addButton.publisher(for: .touchUpInside).sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.didTapAddButtonSubject.send(self.inputTextField.text ?? .empty)
            }
            .store(in: &cancellables)

            deleteButton.publisher(for: .touchUpInside).sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.didTapDeleteButtonSubject.send(self.inputTextField.text ?? .empty)
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - preview

    struct DebugUserDefaultsArrayViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUserDefaultsArrayView()) {
                $0.updateDescription("UserDefaults保存値")
            }
            .frame(height: 200)
        }
    }
#endif
