#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - menu type

    enum DebugAPIMenuType: CaseIterable {
        case debugDelete
        case debugGet
        case debugPost
        case debugPut

        var title: String {
            switch self {
            case .debugDelete:
                return "テスト【DELETE】"

            case .debugGet:
                return "テスト【GET】"

            case .debugPost:
                return "テスト【POST】"

            case .debugPut:
                return "テスト【PUT】"
            }
        }
    }

    // MARK: - section & item

    enum DebugAPIContentViewSection: CaseIterable {
        case main
    }

    enum DebugAPIContentViewItem: Hashable {
        case requestURL(DebugAPIViewModel.API)
        case responseJSON(DebugAPIViewModel.API)
        case responseError(DebugAPIViewModel.API)
    }

    // MARK: - properties & init

    final class DebugAPIContentView: UIView {
        typealias Section = DebugAPIContentViewSection
        typealias Item = DebugAPIContentViewItem
        typealias API = DebugAPIViewModel.API

        var api: API? {
            didSet {
                applySnapshot()
            }
        }

        @Published private(set) var selectedType: DebugAPIMenuType = .debugGet {
            didSet {
                applySnapshot()
            }
        }

        private(set) lazy var didTapSendButtonPublisher = didTapSendButtonSubject.eraseToAnyPublisher()

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

        private lazy var buttonView = VStackView(alignment: .center) {
            menuButton
                .addConstraint {
                    $0.width.equalTo(160)
                    $0.height.equalTo(40)
                }
                .apply(.debugMenuButton)

            sendButton.configure {
                $0.setTitle(L10n.Components.Button.send, for: .normal)
                $0.setTitleColor(.red, for: .normal)
            }
        }

        private var cacheCellHeights: [IndexPath: CGFloat] = [:]
        private var cancellables: Set<AnyCancellable> = .init()

        private let sendButton = UIButton(type: .system)
        private let menuButton = UIButton(type: .system)
        private let tableView = UITableView()

        private let didTapSendButtonSubject = PassthroughSubject<DebugAPIMenuType, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupTableView()
            setupEvent()
            setupMenu()
            applySnapshot()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }

    // MARK: - private methods

    private extension DebugAPIContentView {
        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: [
                    DebugAPIRequestURLCell.self,
                    DebugAPIResponseCell.self
                ])
                $0.backgroundColor = .primary
                $0.separatorStyle = .none
                $0.delegate = self
                $0.dataSource = dataSource
            }
        }

        func setupEvent() {
            sendButton.publisher(for: .touchUpInside).sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.didTapSendButtonSubject.send(self.selectedType)
            }
            .store(in: &cancellables)
        }

        func setupMenu() {
            var actions = [UIMenuElement]()

            DebugAPIMenuType.allCases.forEach { type in
                actions.append(
                    UIAction(
                        title: type.title,
                        state: type == selectedType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedType = type
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
                $0.setTitle(
                    selectedType.title,
                    for: .normal
                )
                $0.showsMenuAsPrimaryAction = true
            }
        }

        func makeCell(
            tableView: UITableView,
            indexPath: IndexPath,
            item: Item
        ) -> UITableViewCell? {
            switch item {
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
            }
        }

        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            if let api {
                dataSourceSnapshot.appendItems(
                    [.requestURL(api)],
                    toSection: .main
                )

                if api.responseJSON != nil {
                    dataSourceSnapshot.appendItems(
                        [.responseJSON(api)],
                        toSection: .main
                    )
                }

                if api.responseError != nil {
                    dataSourceSnapshot.appendItems(
                        [.responseError(api)],
                        toSection: .main
                    )
                }
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
                $0.addSubview(buttonView) {
                    $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
                    $0.leading.trailing.equalToSuperview()
                }

                $0.addSubview(tableView) {
                    $0.top.equalTo(sendButton.snp.bottom).inset(-24)
                    $0.bottom.leading.trailing.equalToSuperview()
                }

                $0.backgroundColor = .primary
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
