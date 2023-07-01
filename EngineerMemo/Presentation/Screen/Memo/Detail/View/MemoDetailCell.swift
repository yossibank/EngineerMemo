import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoDetailCell: UICollectionViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            categoryView.configure {
                $0.inputValue(
                    title: L10n.Memo.category,
                    icon: Asset.memoCategory.image
                )
            }

            titleView.configure {
                $0.inputValue(
                    title: L10n.Memo.title,
                    icon: Asset.memoTitle.image
                )
            }

            contentsView.configure {
                $0.inputValue(
                    title: L10n.Memo.content,
                    icon: Asset.memoContent.image
                )
            }
        }
    }

    private let categoryView = DetailTitleIconView()
    private let titleView = DetailTitleView()
    private let contentsView = DetailTitleView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension MemoDetailCell {
    func configure(_ modelObject: MemoModelObject) {
        titleView.updateValue(modelObject.title)
        contentsView.updateValue(modelObject.content)

        guard let category = modelObject.category else {
            categoryView.isHidden = true
            return
        }

        let iconImage: UIImage? = {
            switch category {
            case .todo:
                return Asset.toDoCategory.image

            case .technical:
                return Asset.technicalCategory.image

            case .interview:
                return Asset.interviewCategory.image

            case .event:
                return Asset.eventCategory.image

            case .tax:
                return Asset.taxCategory.image

            case .other:
                return Asset.otherCategory.image
            }
        }()

        categoryView.isHidden = false
        categoryView.updateValue(category.value)
        categoryView.updateIcon(iconImage)
    }
}

// MARK: - private methods

private extension MemoDetailCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoDetailCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoDetailCell())
        }
    }
#endif
