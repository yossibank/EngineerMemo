import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoDetailCell: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(spacing: 32) {
            VStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.title
                    $0.textColor = .secondary
                    $0.font = .boldSystemFont(ofSize: 18)
                }

                UIView()
                    .addConstraint {
                        $0.height.equalTo(1)
                    }
                    .configure {
                        $0.backgroundColor = .secondary
                    }

                titleLabel.configure {
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.numberOfLines = 0
                }
            }

            VStackView(spacing: 8) {
                UILabel().configure {
                    $0.text = L10n.Memo.content
                    $0.textColor = .secondary
                    $0.font = .boldSystemFont(ofSize: 18)
                }

                UIView()
                    .addConstraint {
                        $0.height.equalTo(1)
                    }
                    .configure {
                        $0.backgroundColor = .secondary
                    }

                contentLabel.configure {
                    $0.font = .systemFont(ofSize: 14)
                    $0.numberOfLines = 0
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

extension MemoDetailCell {
    func configure(_ modelObject: MemoModelObject) {
        titleLabel.text = modelObject.title
        contentLabel.text = modelObject.content
    }
}

// MARK: - private methods

private extension MemoDetailCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .primary
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
