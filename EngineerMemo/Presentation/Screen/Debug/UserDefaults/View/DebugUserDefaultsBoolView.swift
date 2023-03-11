#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsBoolView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            VStackView(spacing: 32) {
                VStackView(alignment: .center, spacing: 16) {
                    titleLabel
                        .modifier(\.text, L10n.Debug.UserDefaults.value)
                        .modifier(\.font, .boldSystemFont(ofSize: 13))

                    descriptionLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                }

                segmentControl
            }
        }

        private let titleLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let segmentControl = UISegmentedControl(items: [true, false].map(\.description))

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugUserDefaultsBoolView {
        func updateSegment(index: Int) {
            segmentControl.selectedSegmentIndex = index
        }

        func updateDescription(_ description: String) {
            descriptionLabel.text = description
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsBoolView {
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
    }

    // MARK: - preview

    struct DebugUserDefaultsBoolViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUserDefaultsBoolView()) {
                $0.updateSegment(index: DataHolder.bool.boolValue)
                $0.updateDescription(DataHolder.bool.description)
            }
            .frame(height: 150)
        }
    }

#endif
