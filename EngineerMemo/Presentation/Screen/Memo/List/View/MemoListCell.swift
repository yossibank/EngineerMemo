import Combine
import UIKit
import UIKitHelper

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
            VStackView(spacing: 4) {
                UILabel().configure {
                    $0.text = L10n.Memo.title
                    $0.textColor = .secondaryGray
                    $0.font = .systemFont(ofSize: 14)
                }

                titleLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.numberOfLines = 1
                }
            }

            VStackView(spacing: 4) {
                UILabel().configure {
                    $0.text = L10n.Memo.content
                    $0.textColor = .secondaryGray
                    $0.font = .systemFont(ofSize: 14)
                }

                contentLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.numberOfLines = 1
                }
            }
        }
    }

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

extension MemoListCell {
    func configure(_ modelObject: MemoModelObject) {
        titleLabel.text = modelObject.title
        contentLabel.text = modelObject.content
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
