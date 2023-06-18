import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoDetailCell: UICollectionViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            categoryStackView
            titleStackView
            contentStackView
        }
    }

    private lazy var categoryStackView = createStackView(.category)
    private lazy var titleStackView = createStackView(.title)
    private lazy var contentStackView = createStackView(.content)

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
            categoryStackView.isHidden = true
            return
        }

        categoryStackView.isHidden = false
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

            case .tax:
                return Asset.taxCategory.image

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

        let contentView: UIView = {
            switch type {
            case .category:
                return HStackView(spacing: 8, layoutMargins: .init(.top, 4)) {
                    categoryImageView.addConstraint {
                        $0.size.equalTo(24)
                    }

                    valueLabel.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                    }
                }

            case .title, .content:
                return valueLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.numberOfLines = 0
                }
            }
        }()

        return VStackView(spacing: 8) {
            HStackView(spacing: 4) {
                UIImageView()
                    .addConstraint {
                        $0.size.equalTo(24)
                    }
                    .configure {
                        $0.image = type.image
                    }

                UILabel().configure {
                    $0.text = type.title
                    $0.textColor = .secondaryGray
                    $0.font = .boldSystemFont(ofSize: 16)
                }

                UIView()
            }

            BorderView().configure {
                $0.changeColor(.secondaryGray)
            }

            contentView
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
