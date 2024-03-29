import Combine
import UIKit

// MARK: - properties & init

final class MemoListCell: UICollectionViewCell {
    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
        }
        .addSubview(categoryImageView) {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var body: UIView {
        VStackView(spacing: 16) {
            titleView.configure {
                $0.setTitle(title: L10n.Memo.title)
            }

            contentsView.configure {
                $0.setTitle(title: L10n.Memo.content)
            }
        }
    }

    private let categoryImageView = UIImageView()
    private let titleView = TitleContentView()
    private let contentsView = TitleContentView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension MemoListCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            contentView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension MemoListCell {
    func configure(_ modelObject: MemoModelObject) {
        titleView.configure {
            $0.setContent(modelObject.title)
            $0.setContentLine(1)
        }

        contentsView.configure {
            $0.setContent(modelObject.content)
            $0.setContentLine(1)
        }

        categoryImageView.image = {
            switch modelObject.category {
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

            case .widget:
                return Asset.widgetCategory.image

            default:
                return nil
            }
        }()
    }
}

// MARK: - private methods

private extension MemoListCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
            $0.apply(.borderView)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoListCell()) {
                $0.configure(
                    MemoModelObjectBuilder()
                        .category(.todo)
                        .build()
                )
            }
        }
    }
#endif
