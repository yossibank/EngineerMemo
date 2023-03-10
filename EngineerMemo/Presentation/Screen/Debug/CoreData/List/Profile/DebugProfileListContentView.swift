#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugProfileListContentViewSection: CaseIterable {
        case main

        var cellType: ProfileBasicCell.Type {
            ProfileBasicCell.self
        }
    }

    enum DebugProfileListContentViewItem: Hashable {
        case main(ProfileModelObject)
    }

    // MARK: - properties & init

    final class DebugProfileListContentView: UIView {
        typealias Section = DebugProfileListContentViewSection
        typealias Item = DebugProfileListContentViewItem
        typealias DataSource = DebugProfileListDataSource

        private(set) lazy var didDeletedModelObjectPublisher = dataSource.didDeletedModelObjectPublisher

        private(set) lazy var dataSource = DataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return self.makeCell(
                tableView: tableView,
                indexPath: indexPath,
                item: item
            )
        }

        private let tableView = UITableView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupTableView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugProfileListContentView {
        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: Section.allCases.map(\.cellType))
                $0.backgroundColor = .primary
                $0.allowsSelection = false
                $0.separatorStyle = .none
                $0.dataSource = dataSource
            }
        }

        func makeCell(
            tableView: UITableView,
            indexPath: IndexPath,
            item: Item
        ) -> UITableViewCell? {
            let cellType = Section.allCases[indexPath.section].cellType

            switch item {
            case let .main(modelObject):
                let cell = tableView.dequeueReusableCell(
                    withType: cellType,
                    for: indexPath
                )

                cell.configure(modelObject)

                return cell
            }
        }
    }

    // MARK: - protocol

    extension DebugProfileListContentView: ContentView {
        func setupView() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugProfileListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileListContentView()) {
                $0.dataSource.modelObject = [
                    ProfileModelObjectBuilder().build()
                ]
            }
        }
    }
#endif
