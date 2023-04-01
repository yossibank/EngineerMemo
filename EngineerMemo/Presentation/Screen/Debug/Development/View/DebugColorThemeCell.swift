#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugColorThemeSegment: Int, CaseIterable {
        case system
        case light
        case dark

        var title: String {
            switch self {
            case .system: return L10n.Debug.Segment.system
            case .light: return L10n.Debug.Segment.light
            case .dark: return L10n.Debug.Segment.dark
            }
        }
    }

    // MARK: - properties & init

    final class DebugColorThemeCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private let segmentControl = UISegmentedControl(
            items: DebugColorThemeSegment.allCases.map(\.title)
        )

        override init(
            style: UITableViewCell.CellStyle,
            reuseIdentifier: String?
        ) {
            super.init(
                style: style,
                reuseIdentifier: reuseIdentifier
            )

            setupView()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override func prepareForReuse() {
            super.prepareForReuse()

            cancellables.removeAll()
        }
    }

    // MARK: - private methods

    private extension DebugColorThemeCell {
        func setupView() {
            configure {
                $0.backgroundColor = .primary
                $0.selectedBackgroundView = .init()
            }

            contentView.addSubview(segmentControl) {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(8)
            }

            segmentControl.configure {
                $0.selectedSegmentIndex = DataHolder.colorTheme.rawValue
                $0.setTitleTextAttributes(
                    [.font: UIFont.boldSystemFont(ofSize: 14)],
                    for: .normal
                )
            }
        }
    }

    // MARK: - preview

    struct DebugColorThemeCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugColorThemeCell())
        }
    }
#endif
