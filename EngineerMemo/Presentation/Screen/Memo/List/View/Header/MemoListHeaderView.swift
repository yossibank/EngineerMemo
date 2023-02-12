import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel(style: .boldSystemFont(size: 12))

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
            .addSubview(titleLabel)
        ])
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
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
