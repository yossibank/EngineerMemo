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
                Asset.penguin.image,
                Asset.elephant.image,
                Asset.fox.image,
                Asset.octopus.image,
                Asset.panda.image,
                Asset.seal.image,
                Asset.sheep.image
            ]

            switch self {
            case .image: return images.randomElement()
            case .none: return nil
            }
        }

        static var defaultImage: UIImage { Asset.penguin.image }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugIconImageSegmentView: UIView {
        typealias Segment = DebugIconImageSegment

        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .addConstraint {
                        $0.width.equalTo(100)
                    }
                    .configure {
                        $0.font = .italicSystemFont(ofSize: 14)
                    }

                segmentControl.configure {
                    $0.selectedSegmentIndex = Segment.image.rawValue
                }
            }
        }

        private let titleLabel = UILabel()
        private let segmentControl = UISegmentedControl(items: Segment.allCases.map(\.title))

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
                $0.addSubview(body) {
                    $0.verticalEdges.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugIconImageSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugIconImageSegmentView(title: "title"))
        }
    }
#endif
