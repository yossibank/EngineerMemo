import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoListCell: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private lazy var baseView = UIView()
        .addSubview(stackView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .configure {
            $0.backgroundColor = .thinGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var stackView: UIView {
        VStackView(spacing: 16) {
            VStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.title
                    $0.textColor = .secondary
                    $0.font = .systemFont(ofSize: 14)
                }

                titleLabel.configure {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.numberOfLines = 2
                }
            }

            VStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.content
                    $0.textColor = .secondary
                    $0.font = .systemFont(ofSize: 14)
                }

                contentLabel.configure {
                    $0.font = .boldSystemFont(ofSize: 12)
                    $0.numberOfLines = 2
                }
            }
        }
    }

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

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension MemoListCell {
    func configure(_ modelObject: MemoModelObject) {
        titleLabel.text = modelObject.title
        contentLabel.text = modelObject.content
    }
}

// MARK: - private methods

private extension MemoListCell {
    func setupView() {
        configure {
            $0.backgroundColor = .primary
        }

        contentView.addSubview(baseView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoListCell()
            )
        }
    }
#endif
