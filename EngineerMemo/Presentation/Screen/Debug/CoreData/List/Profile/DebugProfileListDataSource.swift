#if DEBUG
    import Combine
    import UIKit

    // MARK: - properties & init

    final class DebugProfileListDataSource: UITableViewDiffableDataSource<
        DebugProfileListContentViewSection,
        DebugProfileListContentViewItem
    > {
        typealias Section = DebugProfileListContentViewSection
        typealias Item = DebugProfileListContentViewItem

        var modelObject: [ProfileModelObject] = [] {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var didDeleteModelObjectPublisher = didDeleteModelObjectSubject.eraseToAnyPublisher()

        private let didDeleteModelObjectSubject = PassthroughSubject<ProfileModelObject, Never>()

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
                didDeleteModelObjectSubject.send(modelObject[indexPath.row])
                var snapshot = snapshot()
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
            }
        }
    }

    // MARK: - private methods

    private extension DebugProfileListDataSource {
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
