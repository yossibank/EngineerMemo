import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - section & item

enum SampleListSection {
    case main
}

enum SampleListItem: Hashable {
    case main(SampleModelObject)
}

// MARK: - properties & init

final class SampleListContentView: UIView {
    var modelObject: [SampleModelObject] = [] {
        didSet {
            applySnapshot()
        }
    }

    lazy var didSelectContentPublisher = didSelectContentSubject.eraseToAnyPublisher()

    private var dataSource: UITableViewDiffableDataSource<
        SampleListSection,
        SampleListItem
    >!

    private let didSelectContentSubject = PassthroughSubject<IndexPath, Never>()
    private let tableView = UITableView()
    private let indicator = UIActivityIndicatorView(
        styles: [
            .color(.gray),
            .transform(.init(scaleX: 1.5, y: 1.5))
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension SampleListContentView {
    func configureIndicator(isLoading: Bool) {
        if isLoading {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}

// MARK: - private methods

private extension SampleListContentView {
    func setupTableView() {
        dataSource = configureDataSource()

        tableView.register(
            SampleCell.self,
            forCellReuseIdentifier: SampleCell.className
        )

        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    func configureDataSource() -> UITableViewDiffableDataSource<
        SampleListSection,
        SampleListItem
    > {
        .init(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return self.makeCell(
                tableView: tableView,
                indexPath: indexPath,
                item: item
            )
        }
    }

    func makeCell(
        tableView: UITableView,
        indexPath: IndexPath,
        item: SampleListItem
    ) -> UITableViewCell? {
        switch item {
        case let .main(modelObject):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SampleCell.className,
                    for: indexPath
                ) as? SampleCell
            else {
                return .init()
            }

            cell.configure(modelObject)

            return cell
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<
            SampleListSection,
            SampleListItem
        >()
        dataSourceSnapshot.appendSections([.main])

        modelObject.forEach { object in
            dataSourceSnapshot.appendItems([.main(object)])
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension SampleListContentView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        100
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: false
        )

        didSelectContentSubject.send(indexPath)
    }
}

// MARK: - protocol

extension SampleListContentView: ContentView {
    func setupViews() {
        apply([
            .addSubviews([tableView, indicator]),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SampleListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SampleListContentView()) { view in
                view.modelObject = [
                    SampleModelObjectBuilder()
                        .id(1)
                        .build(),
                    SampleModelObjectBuilder()
                        .id(2)
                        .build(),
                    SampleModelObjectBuilder()
                        .id(3)
                        .build(),
                    SampleModelObjectBuilder()
                        .id(4)
                        .build(),
                    SampleModelObjectBuilder()
                        .id(5)
                        .build(),
                    SampleModelObjectBuilder()
                        .id(6)
                        .build()
                ]
            }
        }
    }
#endif
