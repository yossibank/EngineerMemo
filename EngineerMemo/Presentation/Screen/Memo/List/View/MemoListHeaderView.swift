import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    var cancellables: Set<AnyCancellable> = .init()

    @Published private(set) var selectedCategoryType: MemoCategoryType = .all

    private var categoryTypes = MemoCategoryType.allCases {
        didSet {
            setupCategory()
        }
    }

    private var body: UIView {
        HStackView(alignment: .center, spacing: 8) {
            UILabel().configure {
                $0.text = L10n.Memo.Category.filter
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 14)
            }

            categoryButton.configure {
                $0.setTitleColor(.primary, for: .normal)
                $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
                $0.layer.borderColor = UIColor.primary.cgColor
                $0.layer.borderWidth = 1.0
                $0.layer.cornerRadius = 8
                $0.contentEdgeInsets = .init(.all, 4)
                $0.clipsToBounds = true
            }

            UIView()
        }
    }

    private let categoryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
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

            categoryButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension MemoListHeaderView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }

    func setupCategory() {
        var actions = [UIMenuElement]()

        categoryTypes.forEach { categoryType in
            actions.append(
                UIAction(
                    title: categoryType.title,
                    image: categoryType.image,
                    state: categoryType == selectedCategoryType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedCategoryType = categoryType
                        self?.setupCategory()
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
                .frame(height: 44)
        }
    }
#endif
