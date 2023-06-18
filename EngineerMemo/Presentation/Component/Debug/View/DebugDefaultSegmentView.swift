#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugDefaultSegment: Int, CaseIterable {
        case `default`
        case none

        var title: String {
            switch self {
            case .default: return L10n.Debug.Segment.default
            case .none: return .noSetting
            }
        }

        var skill: SkillModelObject? {
            switch self {
            case .default: return SKillModelObjectBuilder().build()
            case .none: return nil
            }
        }

        var projects: [ProjectModelObject] {
            switch self {
            case .default: return [ProjectModelObjectBuilder().build()]
            case .none: return []
            }
        }

        static var defaultSkill = `default`.skill
        static var defaultProjects = `default`.projects

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugDefaultSegmentView: UIView {
        typealias Segment = DebugDefaultSegment

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
                    $0.selectedSegmentIndex = Segment.default.rawValue
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

    private extension DebugDefaultSegmentView {
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

    struct DebugDefaultSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugDefaultSegmentView(title: "title"))
        }
    }
#endif
