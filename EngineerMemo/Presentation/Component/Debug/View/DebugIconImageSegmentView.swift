#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugIconImageSegment: Int, CaseIterable {
        case image
        case none

        var title: String {
            switch self {
            case .image: return L10n.Debug.Segment.randomImage
            case .none: return .noSetting
            }
        }

        var image: UIImage? {
            let images = [
                ImageResources.profile!,
                ImageResources.house!,
                ImageResources.memo!,
                ImageResources.debug!
            ]

            switch self {
            case .image: return images.randomElement()
            case .none: return nil
            }
        }

        static var defaultImage: UIImage? { ImageResources.house }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugIconImageSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel.configure {
                    $0.font = .italicSystemFont(ofSize: 14)
                }

                segmentControl.configure {
                    $0.selectedSegmentIndex = DebugIconImageSegment.image.rawValue
                }
            }
        }

        private let titleLabel = UILabel()
            .addConstraint {
                $0.width.equalTo(100)
            }

        private let segmentControl = UISegmentedControl(
            items: DebugIconImageSegment.allCases.map(\.title)
        )

        init(title: String) {
            super.init(frame: .zero)

            setupView()

            titleLabel.text = title
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugIconImageSegmentView {
        func setupView() {
            configure {
                $0.backgroundColor = .primary
            }

            addSubview(body) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }

    // MARK: - preview

    struct DebugIconImageSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugIconImageSegmentView(
                    title: "title"
                )
            )
        }
    }
#endif
