import Combine
import UIKit
import UIKitHelper

// MARK: - section

enum MemoListContentViewSection: CaseIterable {
    case main
}

// MARK: - properties & init

final class MemoListContentView: UIView {
    typealias Section = MemoListContentViewSection
    typealias Item = MemoModelObject

    enum ViewType: Int {
        case one = 1
        case two
        case three
    }

    var modelObjects: [MemoModelObject] = [] {
        didSet {
            applySnapshot()
        }
    }

    private(set) lazy var didSelectContentPublisher = didSelectContentSubject.eraseToAnyPublisher()

    private(set) var addBarButton = UIButton(type: .system)
        .addConstraint {
            $0.size.equalTo(32)
        }
        .configure {
            $0.setImage(
                Asset.memoAdd.image
                    .resized(size: .init(width: 32, height: 32))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
        }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )

    private lazy var dataSource = UICollectionViewDiffableDataSource<
        Section,
        Item
    >(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
        guard let self else {
            return .init()
        }

        return collectionView.dequeueConfiguredReusableCell(
            using: self.cellRegistration,
            for: indexPath,
            item: item
        )
    }

    private var collectionViewLayout: UICollectionViewLayout {
        let estimatedHeight: CGFloat = 120

        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: .init(layoutSize: layoutSize),
            count: viewType.rawValue
        )
        group.interItemSpacing = .fixed(8.0)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0

        let sideInset: CGFloat = 8.0
        section.contentInsets = .init(
            top: .zero,
            leading: sideInset,
            bottom: .zero,
            trailing: sideInset
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: MemoListHeaderView.className,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private var viewType: ViewType = .two {
        didSet {
            guard viewType != oldValue else {
                return
            }

            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(
                collectionViewLayout,
                animated: true
            )
        }
    }

    private let cellRegistration = UICollectionView.CellRegistration<
        MemoListCell,
        Item
    > { cell, _, item in
        cell.configure(item)
    }

    private let headerRegistration = UICollectionView.SupplementaryRegistration<
        MemoListHeaderView
    > { _, _, _ in }

    private let didTapCreateButtonSubject = PassthroughSubject<Void, Never>()
    private let didSelectContentSubject = PassthroughSubject<Item, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupCollectionView()
        setupHeaderView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension MemoListContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.backgroundColor = .background
            $0.delegate = self
        }
    }

    func setupHeaderView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            guard let self else {
                return .init()
            }

            let header = collectionView.dequeueConfiguredReusableSupplementary(
                using: self.headerRegistration,
                for: indexPath
            )

            header.button1Publisher.sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.viewType = .one
            }
            .store(in: &header.cancellables)

            header.button2Publisher.sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.viewType = .two
            }
            .store(in: &header.cancellables)

            header.button3Publisher.sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.viewType = .three
            }
            .store(in: &header.cancellables)

            return header
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        modelObjects.forEach {
            dataSourceSnapshot.appendItems(
                [$0],
                toSection: .main
            )
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension MemoListContentView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(
            at: indexPath,
            animated: false
        )

        guard let item = modelObjects[safe: indexPath.item] else {
            return
        }

        didSelectContentSubject.send(item)
    }
}

// MARK: - protocol

extension MemoListContentView: ContentView {
    func setupView() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoListContentView())
        }
    }
#endif
