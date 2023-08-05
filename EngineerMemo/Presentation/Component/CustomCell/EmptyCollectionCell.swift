import Combine
import UIKit

// MARK: - properties & init

final class EmptyCollectionCell: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEmptyButtonPublisher = emptyButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            descriptionLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 14)
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }

            emptyButton.addConstraint {
                $0.width.equalTo(160)
                $0.height.equalTo(48)
            }
        }
    }

    private let descriptionLabel = UILabel()
    private let emptyButton = UIButton(type: .system)

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

extension EmptyCollectionCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension EmptyCollectionCell {
    func configure(with content: EmptyContent) {
        descriptionLabel.text = content.description
        emptyButton.apply(
            .emptyButton(
                title: content.buttonTitle,
                icon: content.buttonIcon
            )
        )
    }
}

// MARK: - private methods

private extension EmptyCollectionCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoEmptyCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: EmptyCollectionCell())
        }
    }
#endif
