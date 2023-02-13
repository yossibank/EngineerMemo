import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var button1Publisher = button1.publisher(for: .touchUpInside)
    private(set) lazy var button2Publisher = button2.publisher(for: .touchUpInside)
    private(set) lazy var button3Publisher = button3.publisher(for: .touchUpInside)

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews([titleLabel, button1, button2, button3]),
            .axis(.horizontal),
            .spacing(16)
        ]
    )

    private let titleLabel = UILabel(
        style: .boldSystemFont(size: 14)
    )

    private let button1 = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4),
            .setTitle("1"),
            .setTitleColor(.theme)
        ]
    )

    private let button2 = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4),
            .setTitle("2"),
            .setTitleColor(.theme)
        ]
    )

    private let button3 = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4),
            .setTitle("3"),
            .setTitleColor(.theme)
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
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
        titleLabel.apply(.text(title))
    }
}

// MARK: - private methods

private extension MemoListHeaderView {
    func setupViews() {
        apply([
            .backgroundColor(.thinGray),
            .addSubview(stackView)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
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
