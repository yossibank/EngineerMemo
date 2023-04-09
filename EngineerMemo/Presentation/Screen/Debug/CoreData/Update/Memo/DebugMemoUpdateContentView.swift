#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugMemoUpdateContentViewSection: Int, CaseIterable {
        case list
        case update

        var cellType: UITableViewCell.Type {
            switch self {
            case .list:
                return DebugUpdateListCell.self

            case .update:
                return DebugMemoUpdateCell.self
            }
        }
    }

    enum DebugMemoUpdateContentViewItem: Hashable {
        case list(MemoModelObject)
        case update
    }

    // MARK: - properties & init

    final class DebugMemoUpdateContentView: UIView {
        typealias Section = DebugMemoUpdateContentViewSection
        typealias Item = DebugMemoUpdateContentViewItem

        var modelObjects: [MemoModelObject] = [] {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var didChangeTitleControlPublisher = didChangeTitleControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeContentControlPublisher = didChangeContentControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeSearchTextPublisher = didChangeSearchTextSubject.eraseToAnyPublisher()
        private(set) lazy var didTapUpdateButtonPublisher = didTapUpdateButtonSubject.eraseToAnyPublisher()

        private lazy var dataSource = UITableViewDiffableDataSource<
            Section,
            Item
        >(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return self.makeCell(
                tableView: tableView,
                indexPath: indexPath,
                item: item
            )
        }

        private var selectedIndex: Int? {
            didSet {
                applySnapshot()
            }
        }

        private let didChangeTitleControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeContentControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeSearchTextSubject = PassthroughSubject<String, Never>()
        private let didTapUpdateButtonSubject = PassthroughSubject<String, Never>()

        private let searchBar = UISearchBar()
        private let tableView = UITableView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupSearchBar()
            setupTableView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugMemoUpdateContentView {
        func setupSearchBar() {
            searchBar.configure {
                $0.enablesReturnKeyAutomatically = false
                $0.backgroundImage = .init()
                $0.delegate = self
            }
        }

        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: Section.allCases.map(\.cellType))
                $0.backgroundColor = .primary
                $0.allowsMultipleSelection = false
                $0.delegate = self
                $0.dataSource = dataSource
            }
        }

        func makeCell(
            tableView: UITableView,
            indexPath: IndexPath,
            item: Item
        ) -> UITableViewCell? {
            let cellType = Section.allCases[indexPath.section].cellType
            let cell = tableView.dequeueReusableCell(
                withType: cellType,
                for: indexPath
            )

            switch item {
            case let .list(modelObject):
                guard let cell = cell as? DebugUpdateListCell else {
                    return .init()
                }

                if let selectedIndex {
                    tableView.selectRow(
                        at: .init(row: selectedIndex, section: Section.list.rawValue),
                        animated: false,
                        scrollPosition: .none
                    )
                }

                cell.configure(modelObject.title ?? .noSetting)

                return cell

            case .update:
                guard let cell = cell as? DebugMemoUpdateCell else {
                    return .init()
                }

                cell.titleControlPublisher.sink { [weak self] value in
                    self?.didChangeTitleControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.contentControlPublisher.sink { [weak self] value in
                    self?.didChangeContentControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.didTapUpdateButtonPublisher.sink { [weak self] _ in
                    guard
                        let self,
                        let selectedIndex = self.selectedIndex,
                        let identifier = self.modelObjects[safe: selectedIndex]?.identifier
                    else {
                        return
                    }

                    self.didTapUpdateButtonSubject.send(identifier)
                    self.searchBar.text = nil
                }
                .store(in: &cell.cancellables)

                return cell
            }
        }

        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            modelObjects.forEach {
                dataSourceSnapshot.appendItems(
                    [.list($0)],
                    toSection: .list
                )
            }

            if selectedIndex != nil {
                dataSourceSnapshot.appendItems(
                    [.update],
                    toSection: .update
                )
            }

            dataSource.apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }

    // MARK: - delegate

    extension DebugMemoUpdateContentView: UISearchBarDelegate {
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            selectedIndex = nil
            tableView.reloadData()

            searchBar.setShowsCancelButton(
                true,
                animated: true
            )
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(
                false,
                animated: true
            )
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(
                false,
                animated: true
            )
        }

        func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            didChangeSearchTextSubject.send(searchText)
        }
    }

    extension DebugMemoUpdateContentView: UITableViewDelegate {
        func tableView(
            _ tableView: UITableView,
            shouldHighlightRowAt indexPath: IndexPath
        ) -> Bool {
            indexPath.section == Section.list.rawValue
        }

        func tableView(
            _ tableView: UITableView,
            heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
            switch Section.allCases[indexPath.section] {
            case .list:
                return 56

            case .update:
                return UITableView.automaticDimension
            }
        }

        func tableView(
            _ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath
        ) {
            if Section.allCases[indexPath.section] == .list {
                selectedIndex = indexPath.row
            }
        }
    }

    // MARK: - protocol

    extension DebugMemoUpdateContentView: ContentView {
        func setupView() {
            addSubview(searchBar) {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }

            addSubview(tableView) {
                $0.top.equalTo(self.searchBar.snp.bottom).inset(-8)
                $0.bottom.leading.trailing.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugMemoUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugMemoUpdateContentView())
        }
    }
#endif
