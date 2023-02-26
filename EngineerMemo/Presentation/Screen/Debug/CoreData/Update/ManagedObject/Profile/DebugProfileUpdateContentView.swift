#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugProfileUpdateContentViewSection: CaseIterable {
        case list
        case update

        var cellType: UITableViewCell.Type {
            switch self {
            case .list:
                return DebugProfileListCell.self

            case .update:
                return DebugProfileUpdateCell.self
            }
        }
    }

    enum DebugProfileUpdateContentViewItem: Hashable {
        case list(ProfileModelObject)
        case update
    }

    // MARK: - properties & init

    final class DebugProfileUpdateContentView: UIView {
        typealias Section = DebugProfileUpdateContentViewSection
        typealias Item = DebugProfileUpdateContentViewItem

        var modelObjects: [ProfileModelObject] = [] {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var addressControlPublisher = addressControlSubject.eraseToAnyPublisher()
        private(set) lazy var birthdayControlPublisher = birthdayControlSubject.eraseToAnyPublisher()
        private(set) lazy var emailControlPublisher = emailControlSubject.eraseToAnyPublisher()
        private(set) lazy var genderControlPublisher = genderControlSubject.eraseToAnyPublisher()
        private(set) lazy var nameControlPublisher = nameControlSubject.eraseToAnyPublisher()
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControlSubject.eraseToAnyPublisher()
        private(set) lazy var stationControlPublisher = stationControlSubject.eraseToAnyPublisher()
        private(set) lazy var didTapUpdateButtonPublisher = didTapUpdateButtonSubject.eraseToAnyPublisher()

        private lazy var dataSource = UITableViewDiffableDataSource<
            Section,
            Item
        >(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return self.makeCell(
                tableVIew: tableView,
                indexPath: indexPath,
                item: item
            )
        }

        private var selectedIndex: Int? {
            didSet {
                applySnapshot()
            }
        }

        private let addressControlSubject = PassthroughSubject<Int, Never>()
        private let birthdayControlSubject = PassthroughSubject<Int, Never>()
        private let emailControlSubject = PassthroughSubject<Int, Never>()
        private let genderControlSubject = PassthroughSubject<Int, Never>()
        private let nameControlSubject = PassthroughSubject<Int, Never>()
        private let phoneNumberControlSubject = PassthroughSubject<Int, Never>()
        private let stationControlSubject = PassthroughSubject<Int, Never>()
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

    private extension DebugProfileUpdateContentView {
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
            tableVIew: UITableView,
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
                guard let cell = cell as? DebugProfileListCell else {
                    return .init()
                }

                cell.selectionStyle = .none
                cell.configure(modelObject.name ?? .noSetting)

                return cell

            case .update:
                guard let cell = cell as? DebugProfileUpdateCell else {
                    return .init()
                }

                cell.selectionStyle = .none
                cell.separatorInset.right = .greatestFiniteMagnitude

                cell.addressControlPublisher.sink { [weak self] value in
                    self?.addressControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.birthdayControlPublisher.sink { [weak self] value in
                    self?.birthdayControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.emailControlPublisher.sink { [weak self] value in
                    self?.emailControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.genderControlPublisher.sink { [weak self] value in
                    self?.genderControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.nameControlPublisher.sink { [weak self] value in
                    self?.nameControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.phoneNumberControlPublisher.sink { [weak self] value in
                    self?.phoneNumberControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.stationControlPublisher.sink { [weak self] value in
                    self?.stationControlSubject.send(value)
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

                    cell.updateView()

                    self.didTapUpdateButtonSubject.send(identifier)
                }
                .store(in: &cell.cancellables)

                return cell
            }
        }

        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            modelObjects.forEach {
                dataSourceSnapshot.appendItems([.list($0)], toSection: .list)
            }

            if selectedIndex != nil {
                dataSourceSnapshot.appendItems([.update], toSection: .update)
            }

            dataSource.apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }

    // MARK: - delegate

    extension DebugProfileUpdateContentView: UISearchBarDelegate {
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            selectedIndex = nil
            searchBar.setShowsCancelButton(true, animated: true)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }

        func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {}
    }

    extension DebugProfileUpdateContentView: UITableViewDelegate {
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

    extension DebugProfileUpdateContentView: ContentView {
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

    struct DebugProfileUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugProfileUpdateContentView()
            )
        }
    }
#endif
