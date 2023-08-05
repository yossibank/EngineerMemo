#if DEBUG
    import SwiftUI
    import UIKit

    enum DebugGenderSegment: Int, CaseIterable {
        case man
        case woman
        case other
        case none

        var title: String {
            switch self {
            case .man: return L10n.Debug.Segment.man
            case .woman: return L10n.Debug.Segment.woman
            case .other: return L10n.Debug.Segment.other
            case .none: return .noSetting
            }
        }

        var gender: ProfileModelObject.Gender? {
            switch self {
            case .man: return .man
            case .woman: return .woman
            case .other: return .other
            case .none: return nil
            }
        }

        static var defaultGender: ProfileModelObject.Gender = .woman

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugGenderSegmentView: UIView {
        typealias Segment = DebugGenderSegment

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
                    $0.selectedSegmentIndex = Segment.woman.rawValue
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

    private extension DebugGenderSegmentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.verticalEdges.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.height.equalTo(40)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugGenderSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugGenderSegmentView(title: "title"))
        }
    }
#endif
