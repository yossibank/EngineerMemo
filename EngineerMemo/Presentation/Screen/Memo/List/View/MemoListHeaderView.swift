import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    var cancellables: Set<AnyCancellable> = .init()

    @Published private(set) var selectedSortType: MemoListSortType = .descending {
        didSet {
            setupSort()
        }
    }

    @Published private(set) var selectedCategoryType: MemoListCategoryType = .all {
        didSet {
            setupCategory()
        }
    }

    private var body: UIView {
        VStackView(spacing: 8) {
            HStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.sort
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                }

                sortButton.apply(.memoMenuButton)

                UIView()
            }

            HStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.Category.filter
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                }

                categoryButton.apply(.memoMenuButton)

                UIView()
            }
        }
    }

    private let sortButton = UIButton(type: .system)
    private let categoryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupSort()
        setupCategory()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [sortButton, categoryButton].forEach {
                $0.configuration?.background.strokeColor = .primary
            }
        }
    }
}

// MARK: - private methods

private extension MemoListHeaderView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview().inset(8)
            }

            $0.backgroundColor = .background
        }
    }

    func setupSort() {
        var actions = [UIMenuElement]()

        MemoListSortType.allCases.forEach { sortType in
            actions.append(
                UIAction(
                    title: sortType.title,
                    image: sortType.image,
                    state: sortType == selectedSortType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedSortType = sortType
                    }
                )
            )
        }

        sortButton.configure {
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
            $0.setTitle(
                selectedSortType.title,
                for: .normal
            )
            $0.setImage(
                selectedSortType.image
                    .resized(size: .init(width: 18, height: 18))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.showsMenuAsPrimaryAction = true
        }
    }

    func setupCategory() {
        var actions = [UIMenuElement]()

        MemoListCategoryType.allCases.forEach { categoryType in
            actions.append(
                UIAction(
                    title: categoryType.title,
                    image: categoryType.image,
                    state: categoryType == selectedCategoryType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedCategoryType = categoryType
                    }
                )
            )
        }

        categoryButton.configure {
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
            $0.setTitle(
                selectedCategoryType.title,
                for: .normal
            )
            $0.setImage(
                selectedCategoryType.image
                    .resized(size: .init(width: 18, height: 18))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.showsMenuAsPrimaryAction = true
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListHeaderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoListHeaderView())
                .frame(height: 80)
        }
    }
#endif
