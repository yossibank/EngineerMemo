#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit

    enum DebugGenderSegment: Int, CaseIterable {
        case man = 0
        case woman
        case other
        case none

        var title: String {
            switch self {
            case .man:
                return "男性"

            case .woman:
                return "女性"

            case .other:
                return "その他"

            case .none:
                return "未設定"
            }
        }

        var gender: ProfileModelObject.Gender {
            switch self {
            case .man:
                return .man

            case .woman:
                return .woman

            case .other:
                return .other

            case .none:
                return .none
            }
        }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - stored properties & init

    final class DebugGenderSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private lazy var stackView: UIStackView = {
            $0.axis = .horizontal
            $0.spacing = 4
            return $0
        }(UIStackView(arrangedSubviews: [
            titleLabel,
            segmentControl
        ]))

        private let titleLabel = UILabel(style: .italic14)

        private let segmentControl: UISegmentedControl = {
            $0.selectedSegmentIndex = DebugGenderSegment.woman.rawValue
            return $0
        }(UISegmentedControl(items: DebugGenderSegment.allCases.map(\.title)))

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugGenderSegmentView {
        func configure(title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugGenderSegmentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(stackView)
        }

        func setupConstraints() {
            stackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(40)
            }

            titleLabel.snp.makeConstraints {
                $0.width.equalTo(100)
            }
        }
    }

    // MARK: - preview

    struct DebugGenderSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugGenderSegmentView()
            ) {
                $0.configure(title: "gender")
            }
        }
    }
#endif
