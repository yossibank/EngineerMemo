import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoDetailCell: UICollectionViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            categoryView
            createStackView(.title)
            createStackView(.content)
        }
    }

    private lazy var categoryView = VStackView(spacing: 8) {
        UILabel().configure {
            $0.text = L10n.Memo.category
            $0.textColor = .secondaryGray
            $0.font = .boldSystemFont(ofSize: 18)
        }

        UIView()
            .addConstraint {
                $0.height.equalTo(1)
            }
            .configure {
                $0.backgroundColor = .secondaryGray
            }

        HStackView(alignment: .center, spacing: 8) {
            categoryImageView.addConstraint {
                $0.size.equalTo(24)
            }

            categoryLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
            }

            UIView()
        }
    }

    private let categoryLabel = UILabel()
    private let categoryImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

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
        titleLabel.text = modelObject.title
        contentLabel.text = modelObject.content

        guard let category = modelObject.category else {
            categoryView.isHidden = true
            return
        }

        categoryView.isHidden = false
        categoryLabel.text = category.value
        categoryImageView.image = {
            switch category {
            case .todo:
                return Asset.toDoCategory.image

            case .technical:
                return Asset.technicalCategory.image

            case .interview:
                return Asset.interviewCategory.image

            case .event:
                return Asset.eventCategory.image

            case .other:
                return Asset.otherCategory.image
            }
        }()
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

    func createStackView(_ type: MemoContentType) -> UIStackView {
        let valueLabel: UILabel

        switch type {
        case .category:
            valueLabel = categoryLabel

        case .title:
            valueLabel = titleLabel

        case .content:
            valueLabel = contentLabel
        }

        return VStackView(spacing: 8) {
            UILabel().configure {
                $0.text = type.title
                $0.textColor = .secondaryGray
                $0.font = .boldSystemFont(ofSize: 18)
            }

            UIView()
                .addConstraint {
                    $0.height.equalTo(1)
                }
                .configure {
                    $0.backgroundColor = .secondaryGray
                }

            valueLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
                $0.numberOfLines = 0
            }
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
