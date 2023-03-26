#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsEnumView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            VStackView(spacing: 32) {
                VStackView(alignment: .center, spacing: 16) {
                    titleLabel.configure {
                        $0.text = L10n.Debug.UserDefaults.value
                        $0.font = .boldSystemFont(ofSize: 13)
                    }

                    descriptionLabel.configure {
                        $0.font = .boldSystemFont(ofSize: 16)
                    }
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
            WrapperView(view: DebugUserDefaultsEnumView()) {
                $0.updateSegment(
                    items: DataHolder.Sample.allCases.map(\.description),
                    index: DataHolder.sample.rawValue
                )
                $0.updateDescription(DataHolder.sample.description)
            }
            .frame(height: 200)
        }
    }
#endif
