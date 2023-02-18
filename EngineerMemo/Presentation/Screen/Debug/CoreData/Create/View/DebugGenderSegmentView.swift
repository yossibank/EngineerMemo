#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugGenderSegment: Int, CaseIterable {
        case man = 0
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

        var gender: ProfileModelObject.Gender {
            switch self {
            case .man: return .man
            case .woman: return .woman
            case .other: return .other
            case .none: return .none
            }
        }

        static var defaultGender: ProfileModelObject.Gender = .woman

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugGenderSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .modifier(\.font, .italicSystemFont(ofSize: 14))

                segmentControl
                    .modifier(\.selectedSegmentIndex, DebugGenderSegment.woman.rawValue)
            }
        }

        private let titleLabel = UILabel()
            .configure {
                $0.snp.makeConstraints {
                    $0.width.equalTo(100)
                }
            }

        private let segmentControl = UISegmentedControl(
            items: DebugGenderSegment.allCases.map(\.title)
        )

        init(title: String) {
            super.init(frame: .zero)

            setupViews()

            titleLabel.modifier(\.text, title)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugGenderSegmentView {
        func setupViews() {
            modifier(\.backgroundColor, .primary)

            addSubview(body) {
                $0.snp.makeConstraints {
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(16)
                    $0.height.equalTo(40)
                }
            }
        }
    }

    // MARK: - preview

    struct DebugGenderSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugGenderSegmentView(
                    title: "title"
                )
            )
        }
    }
#endif
