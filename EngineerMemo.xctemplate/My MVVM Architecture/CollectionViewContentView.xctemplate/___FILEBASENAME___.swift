import Combine
import SnapKit
import UIKit
import UIStyle

// TODO: 各セクション、アイテム(必要な場合は命名変更、別ファイルで管理)

enum ___FILEBASENAME___Section: CaseIterable {
    case main
}

enum ___FILEBASENAME___Item: Hashable {
    case main(String)
}

// MARK: - properties & init

final class ___FILEBASENAME___: UIView {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )

    private var dataSource: UICollectionViewDiffableDataSource<
        ___FILEBASENAME___Section,
        ___FILEBASENAME___Item
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
        ___FILEBASENAME___Item
    > { cell, _, item in
        switch item {
        case let .main(text):
            var configuration = cell.defaultContentConfiguration()
            configuration.text = text
            cell.contentConfiguration = configuration
        }
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

// MARK: - internal methods

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {
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
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<
            ___FILEBASENAME___Section,
            ___FILEBASENAME___Item
        >()
        dataSourceSnapshot.appendSections(___FILEBASENAME___Section.allCases)

        ["text1", "text2", "text3", "text4", "text5"].forEach {
            dataSourceSnapshot.appendItems([.main($0)], toSection: .main)
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - protocol

extension ___FILEBASENAME___: ContentView {
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

    struct ___FILEBASENAME___Preview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ___FILEBASENAME___()
            )
        }
    }
#endif
