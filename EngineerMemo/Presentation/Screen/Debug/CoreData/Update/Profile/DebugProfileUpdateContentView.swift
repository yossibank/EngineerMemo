#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugProfileUpdateContentViewSection: Int, CaseIterable {
        case list
        case update

        var cellType: UITableViewCell.Type {
            switch self {
            case .list:
                return DebugUpdateListCell.self

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

        private(set) lazy var didChangeAddressControlPublisher = didChangeAddressControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeBirthdayControlPublisher = didChangeBirthdayControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeEmailControlPublisher = didChangeEmailControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeGenderControlPublisher = didChangeGenderControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeIconImageControlPublisher = didChangeIconImageControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeNameControlPublisher = didChangeNameControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangePhoneNumberControlPublisher = didChangePhoneNumberControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeStationControlPublisher = didChangeStationControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeSkillControlPublisher = didChangeSkillControlSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeProjectControlPublisher = didChangeProjectControlSubject.eraseToAnyPublisher()
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

        private let didChangeAddressControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeBirthdayControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeEmailControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeGenderControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeIconImageControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeNameControlSubject = PassthroughSubject<Int, Never>()
        private let didChangePhoneNumberControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeStationControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeSkillControlSubject = PassthroughSubject<Int, Never>()
        private let didChangeProjectControlSubject = PassthroughSubject<Int, Never>()
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
                $0.backgroundColor = .background
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

                cell.configure(modelObject.name ?? .noSetting)

                return cell

            case .update:
                guard let cell = cell as? DebugProfileUpdateCell else {
                    return .init()
                }

                cell.addressControlPublisher.sink { [weak self] value in
                    self?.didChangeAddressControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.birthdayControlPublisher.sink { [weak self] value in
                    self?.didChangeBirthdayControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.emailControlPublisher.sink { [weak self] value in
                    self?.didChangeEmailControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.genderControlPublisher.sink { [weak self] value in
                    self?.didChangeGenderControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.iconImageControlPublisher.sink { [weak self] value in
                    self?.didChangeIconImageControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.nameControlPublisher.sink { [weak self] value in
                    self?.didChangeNameControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.phoneNumberControlPublisher.sink { [weak self] value in
                    self?.didChangePhoneNumberControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.stationControlPublisher.sink { [weak self] value in
                    self?.didChangeStationControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.skillControlPublisher.sink { [weak self] value in
                    self?.didChangeSkillControlSubject.send(value)
                }
                .store(in: &cell.cancellables)

                cell.projectControlPublisher.sink { [weak self] value in
                    self?.didChangeProjectControlSubject.send(value)
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

    extension DebugProfileUpdateContentView: UISearchBarDelegate {
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

    extension DebugProfileUpdateContentView: UITableViewDelegate {
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
            WrapperView(view: DebugProfileUpdateContentView())
        }
    }
#endif
