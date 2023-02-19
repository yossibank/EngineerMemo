import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var button1Publisher = button1.publisher(for: .touchUpInside)
    private(set) lazy var button2Publisher = button2.publisher(for: .touchUpInside)
    private(set) lazy var button3Publisher = button3.publisher(for: .touchUpInside)

    private var body: UIView {
        HStackView(spacing: 16) {
            titleLabel
                .modifier(\.font, .boldSystemFont(ofSize: 14))

            button1
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)

            button2
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)

            button3
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)
        }
    }

    private let titleLabel = UILabel()

    private let button1 = UIButton(type: .system)
        .configure {
            $0.setTitle("1", for: .normal)
            $0.setTitleColor(.theme, for: .normal)
        }

    private let button2 = UIButton(type: .system)
        .configure {
            $0.setTitle("2", for: .normal)
            $0.setTitleColor(.theme, for: .normal)
        }

    private let button3 = UIButton(type: .system)
        .configure {
            $0.setTitle("3", for: .normal)
            $0.setTitleColor(.theme, for: .normal)
        }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension MemoListHeaderView {
    func configure(title: String) {
        titleLabel.modifier(\.text, title)
    }
}

// MARK: - private methods

private extension MemoListHeaderView {
    func setupViews() {
        modifier(\.backgroundColor, .thinGray)

        addSubview(body) {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListHeaderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoListHeaderView()
            )
        }
    }
#endif
