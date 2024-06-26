#if DEBUG
    import Combine
    import SwiftUI
    import UIKit

    // MARK: - menu type

    enum DebugAPIMenuType: CaseIterable {
        case debugDelete
        case debugGet
        case debugPost
        case debugPut

        var title: String {
            switch self {
            case .debugDelete: L10n.Debug.Api.debugDelete
            case .debugGet: L10n.Debug.Api.debugGet
            case .debugPost: L10n.Debug.Api.debugPost
            case .debugPut: L10n.Debug.Api.debugPut
            }
        }

        var hasPathComponent: Bool {
            switch self {
            case .debugDelete: true
            case .debugGet: false
            case .debugPost: false
            case .debugPut: true
            }
        }

        var hasParameters: Bool {
            switch self {
            case .debugDelete: false
            case .debugGet: true
            case .debugPost: true
            case .debugPut: true
            }
        }
    }

    // MARK: - section & item

    enum DebugAPIContentViewSection: CaseIterable {
        case main
        case loading
    }

    enum DebugAPIContentViewItem: Hashable {
        case pathComponent
        case parameters([DebugAPIViewModel.Parameters])
        case requestURL(DebugAPIViewModel.APIInfo)
        case responseJSON(DebugAPIViewModel.APIResult)
        case responseError(DebugAPIViewModel.APIResult)
        case loading
    }

    // MARK: - properties & init

    final class DebugAPIContentView: UIView {
        typealias Section = DebugAPIContentViewSection
        typealias Item = DebugAPIContentViewItem
        typealias APIInfo = DebugAPIViewModel.APIInfo
        typealias APIResult = DebugAPIViewModel.APIResult

        var apiInfo: APIInfo? {
            didSet {
                applySnapshot()
            }
        }

        var apiResult: APIResult? {
            didSet {
                applySnapshot()
            }
        }

        var isLoading = false {
            didSet {
                applySnapshot()
            }
        }

        @Published private(set) var menuType: DebugAPIMenuType = .debugGet {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var didChangePathTextFieldPublisher = didChangePathTextFieldSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeUserIdTextFieldPublisher = didChangeUserIdTextFieldSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeIdTextFieldPublisher = didChangeIdTextFieldSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeTitleTextFieldPublisher = didChangeTitleTextFieldSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeBodyTextFieldPublisher = didChangeBodyTextFieldSubject.eraseToAnyPublisher()
        private(set) lazy var didTapSendButtonPublisher = didTapSendButtonSubject.eraseToAnyPublisher()

        private(set) lazy var barButton = UIButton(type: .system)
            .addConstraint {
                $0.width.equalTo(80)
                $0.height.equalTo(32)
            }
            .apply(.sendNavigationButton)

        private lazy var dataSource = UITableViewDiffableDataSource<
            Section,
            Item
        >(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return makeCell(
                tableView: tableView,
                indexPath: indexPath,
                item: item
            )
        }

        private var cacheCellHeights: [IndexPath: CGFloat] = [:]
        private var cancellables = Set<AnyCancellable>()

        private let menuButton = UIButton(type: .system)
            .addConstraint {
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }
            .apply(.debugMenuButton)

        private let tableView = UITableView()

        private let didChangePathTextFieldSubject = PassthroughSubject<Int, Never>()
        private let didChangeUserIdTextFieldSubject = PassthroughSubject<Int?, Never>()
        private let didChangeIdTextFieldSubject = PassthroughSubject<Int, Never>()
        private let didChangeTitleTextFieldSubject = PassthroughSubject<String, Never>()
        private let didChangeBodyTextFieldSubject = PassthroughSubject<String, Never>()
        private let didTapSendButtonSubject = PassthroughSubject<DebugAPIMenuType, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupMenu()
            setupBarButton()
            setupTableView()
            applySnapshot()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - override methods

    extension DebugAPIContentView {
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                barButton.layer.borderColor = UIColor.primary.cgColor
            }
        }
    }

    // MARK: - private methods

    private extension DebugAPIContentView {
        func setupMenu() {
            var actions = [UIMenuElement]()

            for type in DebugAPIMenuType.allCases {
                actions.append(
                    UIAction(
                        title: type.title,
                        state: type == menuType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.apiInfo = nil
                            self?.apiResult = nil
                            self?.menuType = type
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.configure {
                $0.menu = .init(
                    title: .empty,
                    options: .displayInline,
                    children: actions
                )
                $0.setTitle(menuType.title, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }

        func setupBarButton() {
            barButton.publisher(for: .touchUpInside)
                .receive(on: DispatchQueue.main)
                .weakSink(with: self, cancellables: &cancellables) {
                    $0.didTapSendButtonSubject.send($0.menuType)
                }
        }

        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: [
                    DebugPathComponentCell.self,
                    DebugParametersCell.self,
                    DebugAPIRequestURLCell.self,
                    DebugAPIResponseCell.self,
                    DebugAPILoadingCell.self
                ])
                $0.backgroundColor = .background
                $0.separatorStyle = .none
                $0.delegate = self
                $0.dataSource = dataSource
            }
        }

        func makeCell(
            tableView: UITableView,
            indexPath: IndexPath,
            item: Item
        ) -> UITableViewCell? {
            switch item {
            case .pathComponent:
                let cell = tableView.dequeueReusableCell(
                    withType: DebugPathComponentCell.self,
                    for: indexPath
                )

                cell.didChangePathTextFieldPublisher
                    .compactMap { Int($0) }
                    .weakSink(with: self, cancellables: &cell.cancellables) {
                        $0.didChangePathTextFieldSubject.send($1)
                    }

                return cell

            case let .parameters(params):
                let cell = tableView.dequeueReusableCell(
                    withType: DebugParametersCell.self,
                    for: indexPath
                )

                cell.cancellables.formUnion([
                    cell.didChangeUserIdTextFieldPublisher
                        .weakSink(with: self) {
                            if let numberId = Int($1) {
                                $0.didChangeUserIdTextFieldSubject.send(numberId)
                            } else {
                                $0.didChangeUserIdTextFieldSubject.send(nil)
                            }
                        },
                    cell.didChangeIdTextFieldPublisher
                        .compactMap { Int($0) }
                        .weakSink(with: self) {
                            $0.didChangeIdTextFieldSubject.send($1)
                        },
                    cell.didChangeTitleTextFieldPublisher
                        .compactMap { $0 }
                        .weakSink(with: self) {
                            $0.didChangeTitleTextFieldSubject.send($1)
                        },
                    cell.didChangeBodyTextFieldPublisher
                        .compactMap { $0 }
                        .weakSink(with: self) {
                            $0.didChangeBodyTextFieldSubject.send($1)
                        }
                ])

                cell.configure(with: params)

                return cell

            case let .requestURL(api):
                let cell = tableView.dequeueReusableCell(
                    withType: DebugAPIRequestURLCell.self,
                    for: indexPath
                )

                cell.configure(
                    httpMethod: api.httpMethod,
                    requestURL: api.requestURL
                )

                return cell

            case let .responseJSON(api):
                let cell = tableView.dequeueReusableCell(
                    withType: DebugAPIResponseCell.self,
                    for: indexPath
                )

                cell.configure(with: api.responseJSON)

                return cell

            case let .responseError(api):
                let cell = tableView.dequeueReusableCell(
                    withType: DebugAPIResponseCell.self,
                    for: indexPath
                )

                cell.configure(with: api.responseError)

                return cell

            case .loading:
                let cell = tableView.dequeueReusableCell(
                    withType: DebugAPILoadingCell.self,
                    for: indexPath
                )

                cell.configure(with: isLoading)

                return cell
            }
        }

        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            if let apiInfo {
                dataSourceSnapshot.appendItems(
                    [.requestURL(apiInfo)],
                    toSection: .main
                )
            }

            if menuType.hasPathComponent {
                dataSourceSnapshot.appendItems(
                    [.pathComponent],
                    toSection: .main
                )
            }

            if menuType.hasParameters {
                switch menuType {
                case .debugDelete:
                    break

                case .debugGet:
                    dataSourceSnapshot.appendItems(
                        [.parameters([.userId])],
                        toSection: .main
                    )

                case .debugPost:
                    dataSourceSnapshot.appendItems(
                        [.parameters([.userId, .title, .body])],
                        toSection: .main
                    )

                case .debugPut:
                    dataSourceSnapshot.appendItems(
                        [.parameters([.userId, .id, .title, .body])],
                        toSection: .main
                    )
                }
            }

            if let apiResult {
                if apiResult.responseJSON != nil {
                    dataSourceSnapshot.appendItems(
                        [.responseJSON(apiResult)],
                        toSection: .main
                    )
                }

                if apiResult.responseError != nil {
                    dataSourceSnapshot.appendItems(
                        [.responseError(apiResult)],
                        toSection: .main
                    )
                }
            }

            if isLoading {
                dataSourceSnapshot.appendItems(
                    [.loading],
                    toSection: .loading
                )
            }

            dataSource.apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }

    // MARK: - delegate

    extension DebugAPIContentView: UITableViewDelegate {
        func tableView(
            _ tableView: UITableView,
            willDisplay cell: UITableViewCell,
            forRowAt indexPath: IndexPath
        ) {
            cacheCellHeights[indexPath] = ceil(cell.bounds.height)
        }

        func tableView(
            _ tableView: UITableView,
            estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
            if let height = cacheCellHeights[indexPath] {
                return height
            }

            return tableView.estimatedRowHeight
        }
    }

    // MARK: - protocol

    extension DebugAPIContentView: ContentView {
        func setupView() {
            configure {
                $0.addSubview(menuButton) {
                    $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
                    $0.centerX.equalToSuperview()
                }

                $0.addSubview(tableView) {
                    $0.top.equalTo(menuButton.snp.bottom).inset(-8)
                    $0.bottom.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(12)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugAPIContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugAPIContentView())
        }
    }
#endif
