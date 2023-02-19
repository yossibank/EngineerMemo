#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugProfileListContentView: UIView {
        var modelObject: [ProfileModelObject] = []

        private(set) lazy var didDeleteModelObjectPublisher = didDeleteModelObjectSubject.eraseToAnyPublisher()

        private let didDeleteModelObjectSubject = PassthroughSubject<ProfileModelObject, Never>()

        private let tableView = UITableView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupTableView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugProfileListContentView {
        func reload() {
            tableView.reloadData()
        }
    }

    // MARK: - private methods

    private extension DebugProfileListContentView {
        func setupTableView() {
            tableView.modifier(\.backgroundColor, .primary)
            tableView.registerCell(with: ProfileBasicCell.self)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            tableView.dataSource = self
        }
    }

    // MARK: - delegate

    extension DebugProfileListContentView: UITableViewDataSource {
        func tableView(
            _ tableView: UITableView,
            numberOfRowsInSection section: Int
        ) -> Int {
            modelObject.count
        }

        func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withType: ProfileBasicCell.self,
                for: indexPath
            )

            if let modelObject = modelObject[safe: indexPath.row] {
                cell.configure(modelObject)
            }

            return cell
        }

        func tableView(
            _ tableView: UITableView,
            canEditRowAt indexPath: IndexPath
        ) -> Bool {
            true
        }

        func tableView(
            _ tableView: UITableView,
            commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath
        ) {
            if editingStyle == .delete {
                didDeleteModelObjectSubject.send(modelObject[indexPath.row])
                modelObject.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - protocol

    extension DebugProfileListContentView: ContentView {
        func setupViews() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugProfileListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileListContentView()) {
                $0.modelObject = [ProfileModelObjectBuilder().build()]
            }
        }
    }
#endif
