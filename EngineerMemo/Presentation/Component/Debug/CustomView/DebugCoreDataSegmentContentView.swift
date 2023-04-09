#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugCoreDataSegmentContentView: UIView {
        enum ButtonType {
            case create
            case update
        }

        private(set) lazy var didTapActionButtonPublisher = actionButton.publisher(for: .touchUpInside)

        private var cancellables: Set<AnyCancellable> = .init()

        private var body: UIView {
            VStackView(spacing: 16) {
                contentView

                UIView()
                    .addSubview(actionButton) {
                        $0.centerX.equalToSuperview()
                        $0.width.equalTo(160)
                        $0.height.equalTo(48)
                    }
                    .addConstraint {
                        $0.height.equalTo(48)
                    }
            }
        }

        private let contentView = UIView()
        private let actionButton = UIButton(type: .system)
        private let buttonType: ButtonType

        init(_ buttonType: ButtonType) {
            self.buttonType = buttonType

            super.init(frame: .zero)

            setupView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                actionButton.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataSegmentContentView {
        func setupContentView(view: UIView) {
            contentView.addSubview(view) {
                $0.edges.equalToSuperview()
            }

            let defaultViewStyle: ViewStyle<UIButton>
            let updatedViewStyle: ViewStyle<UIButton>

            switch buttonType {
            case .create:
                defaultViewStyle = .debugCreateButton
                updatedViewStyle = .debugCreateDoneButton

            case .update:
                defaultViewStyle = .debugUpdateButton
                updatedViewStyle = .debugUpdateDoneButton
            }

            actionButton.apply(defaultViewStyle)

            didTapActionButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.actionButton.apply(updatedViewStyle)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.actionButton.apply(defaultViewStyle)
                    }
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugCoreDataSegmentContentView: ContentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.edges.equalToSuperview()
                }

                $0.backgroundColor = .primary
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataSegmentContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCoreDataSegmentContentView(.create))
        }
    }
#endif
