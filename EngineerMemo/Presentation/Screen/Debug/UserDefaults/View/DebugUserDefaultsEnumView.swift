#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsEnumView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            VStackView(alignment: .center, spacing: 32) {
                VStackView(spacing: 8) {
                    titleLabel
                        .modifier(\.text, L10n.Debug.UserDefaults.value)
                        .modifier(\.font, .boldSystemFont(ofSize: 13))
                        .modifier(\.textAlignment, .center)

                    descriptionLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                        .modifier(\.numberOfLines, 0)
                        .modifier(\.textAlignment, .center)
                }

                segmentControl
            }
        }

        private let titleLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let segmentControl = UISegmentedControl()

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

    extension DebugUserDefaultsEnumView {
        func updateSegment(
            items: [String],
            index: Int
        ) {
            items.enumerated().forEach {
                segmentControl.insertSegment(
                    withTitle: $1,
                    at: $0,
                    animated: false
                )
            }

            segmentControl.selectedSegmentIndex = index
        }

        func updateDescription(_ description: String) {
            descriptionLabel.text = description
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsEnumView {
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

    struct DebugUserDefaultsEnumViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugUserDefaultsEnumView()
            )
        }
    }
#endif
