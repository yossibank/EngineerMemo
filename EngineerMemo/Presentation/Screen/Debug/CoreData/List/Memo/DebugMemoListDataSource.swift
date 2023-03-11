#if DEBUG
    import Combine
    import UIKit

    // MARK: - properties & init

    final class DebugMemoListDataSource: UITableViewDiffableDataSource<
        DebugMemoListContentViewSection,
        DebugMemoListContentViewItem
    > {
        typealias Section = DebugMemoListContentViewSection
        typealias Item = DebugMemoListContentViewItem

        var modelObject: [MemoModelObject] = [] {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var didDeletedModelObjectPublisher = didDeletedModelObjectSubject.eraseToAnyPublisher()

        private let didDeletedModelObjectSubject = PassthroughSubject<MemoModelObject, Never>()

        override func tableView(
            _ tableView: UITableView,
            canEditRowAt indexPath: IndexPath
        ) -> Bool {
            true
        }

        override func tableView(
            _ tableView: UITableView,
            commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath
        ) {
            guard let item = itemIdentifier(for: indexPath) else {
                return
            }

            if editingStyle == .delete {
                didDeletedModelObjectSubject.send(modelObject[indexPath.row])
                var snapshot = snapshot()
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
            }
        }
    }

    // MARK: - private methods

    private extension DebugMemoListDataSource {
        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            modelObject.forEach {
                dataSourceSnapshot.appendItems([.main($0)], toSection: .main)
            }

            apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }
#endif
