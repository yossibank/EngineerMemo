import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class MemoListContentView: UIView {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )

    private var dataSource: UICollectionViewDiffableDataSource<
        MemoListSection,
        MemoItem
    >!

    private let collectionViewLayout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)

        return .list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
    }

    private let cellRegistration = UICollectionView.CellRegistration<
        UICollectionViewListCell,
        MemoItem
    > { cell, _, memo in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = memo.title
        cell.contentConfiguration = configuration
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupDataSource()
        apply()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension MemoListContentView {
    func setupDataSource() {
        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else {
                return .init()
            }

            return collectionView.dequeueConfiguredReusableCell(
                using: self.cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    func apply() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<MemoListSection, MemoItem>()
        dataSourceSnapshot.appendSections(MemoListSection.allCases)
        dataSourceSnapshot.appendItems([.init(title: "Sample")], toSection: .main)

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - protocol

extension MemoListContentView: ContentView {
    func setupViews() {
        apply([
            .addSubview(collectionView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoListContentView()
            )
        }
    }
#endif
