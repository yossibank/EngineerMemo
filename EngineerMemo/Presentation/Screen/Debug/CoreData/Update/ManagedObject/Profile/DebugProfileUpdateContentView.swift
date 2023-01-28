#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugProfileUpdateContentView: UIView {
        var modelObject: [ProfileModelObject] = [] {
            didSet {
                searchObject = modelObject
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

        private var searchObject: [ProfileModelObject] = [] {
            didSet {
                tableView.reloadData()
            }
        }

        private var selectedIndex: Int? {
            didSet {
                tableView.reloadData()
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

            setupViews()
            setupConstraints()
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
            searchBar.enablesReturnKeyAutomatically = false
            searchBar.backgroundImage = .init()
            searchBar.delegate = self
        }

        func setupTableView() {
            tableView.registerCells(
                with: [
                    UITableViewCell.self,
                    DebugProfileUpdateCell.self
                ]
            )

            tableView.rowHeight = UITableView.automaticDimension
            tableView.allowsMultipleSelection = false
            tableView.delegate = self
            tableView.dataSource = self
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
        ) {
            if searchText.isEmpty {
                searchObject = modelObject
            } else {
                searchObject = modelObject
                    .filter { $0.name != nil }
                    .filter { $0.name!.lowercased().contains(searchText.lowercased()) }
            }
        }
    }

    extension DebugProfileUpdateContentView: UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            DebugProfileUpdateSection.allCases.count
        }

        func tableView(
            _ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath
        ) {
            if DebugProfileUpdateSection.allCases[indexPath.section] == .list {
                selectedIndex = indexPath.row
            }
        }
    }

    extension DebugProfileUpdateContentView: UITableViewDataSource {
        func tableView(
            _ tableView: UITableView,
            numberOfRowsInSection section: Int
        ) -> Int {
            let section = DebugProfileUpdateSection.allCases[section]

            switch section {
            case .list:
                return searchObject.count

            case .update:
                return selectedIndex != nil ? 1 : 0
            }
        }

        func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            let section = DebugProfileUpdateSection.allCases[indexPath.section]

            switch section {
            case .list:
                let cell = tableView.dequeueReusableCell(
                    withType: UITableViewCell.self,
                    for: indexPath
                )

                if let modelObject = searchObject[safe: indexPath.row] {
                    var content = cell.defaultContentConfiguration()
                    content.text = "名前: \(modelObject.name ?? .noSetting)"
                    cell.contentConfiguration = content
                }

                if let selectedIndex {
                    cell.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
                } else {
                    cell.accessoryType = .none
                }

                cell.selectionStyle = .none

                return cell

            case .update:
                let cell = tableView.dequeueReusableCell(
                    withType: DebugProfileUpdateCell.self,
                    for: indexPath
                )

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
                        let identifier = self.searchObject[safe: selectedIndex]?.identifier
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
    }

    // MARK: - protocol

    extension DebugProfileUpdateContentView: ContentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(searchBar)
            addSubview(tableView)
        }

        func setupConstraints() {
            searchBar.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }

            tableView.snp.makeConstraints {
                $0.top.equalTo(searchBar.snp.bottom).inset(-8)
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
