#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugProfileListContentView: UIView {
        var modelObject: [ProfileModelObject] = [] {
            didSet {
                tableView.reloadData()
            }
        }

        private let tableView = UITableView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
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
    }

    // MARK: - protocol

    extension DebugProfileListContentView: ContentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(tableView)
        }

        func setupConstraints() {
            tableView.snp.makeConstraints {
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
