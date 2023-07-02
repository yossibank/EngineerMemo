import Combine
import UIKit
import UIKitHelper

enum ColorThemeSegment: Int, CaseIterable {
    case system
    case light
    case dark

    var title: String {
        switch self {
        case .system: return L10n.Setting.ColorTheme.system
        case .light: return L10n.Setting.ColorTheme.light
        case .dark: return L10n.Setting.ColorTheme.dark
        }
    }
}

// MARK: - properties & init

final class SettingColorThemeCell: UICollectionViewCell {
    typealias Segment = ColorThemeSegment

    var cancellables = Set<AnyCancellable>()

    private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

    private var body: UIView {
        HStackView {
            segmentControl.configure {
                $0.selectedSegmentIndex = DataHolder.colorTheme.rawValue
                $0.setTitleTextAttributes(
                    [.font: UIFont.boldSystemFont(ofSize: 11)],
                    for: .normal
                )
            }
        }
    }

    private let segmentControl = UISegmentedControl(items: Segment.allCases.map(\.title))

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension SettingColorThemeCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            contentView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension SettingColorThemeCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
            $0.apply(.borderView)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SettingColorThemeCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SettingColorThemeCell())
        }
    }
#endif
