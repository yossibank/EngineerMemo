#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section

    enum DebugProjectListContentViewSection: CaseIterable {
        case main

        var cellType: DebugProjectListCell.Type {
            DebugProjectListCell.self
        }
    }

    // MARK: - properties & init

    final class DebugProjectListContentView: UIView {
        typealias Section = DebugProjectListContentViewSection
        typealias Item = ProfileModelObject
        typealias DataSource = DebugProjectListDataSource

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

    private extension DebugProjectListContentView {
        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: Section.allCases.map(\.cellType))
                $0.backgroundColor = .background
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
            let cell = tableView.dequeueReusableCell(
                withType: DebugProjectListContentViewSection.main.cellType,
                for: indexPath
            )

            cell.configure(item)

            return cell
        }
    }

    // MARK: - protocol

    extension DebugProjectListContentView: ContentView {
        func setupView() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugProjectListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProjectListContentView()) {
                $0.dataSource.modelObjects = [
                    ProfileModelObjectBuilder()
                        .projects([ProjectModelObjectBuilder().build()])
                        .build()
                ]
            }
        }
    }
#endif
