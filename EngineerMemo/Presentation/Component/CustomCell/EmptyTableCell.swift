import Combine
import UIKit
import UIKitHelper

// MARK: - empty structure

struct EmptyContent {
    let description: String
    let buttonTitle: String?
    let buttonIcon: UIImage?
}

// MARK: - properties & init

final class EmptyTableCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEmptyButtonPublisher = emptyButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(emptyView) {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private lazy var emptyView = VStackView(alignment: .center, spacing: 24) {
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

    private let descriptionLabel = UILabel()
    private let emptyButton = UIButton(type: .system)

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - override methods

extension EmptyTableCell {
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

extension EmptyTableCell {
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

private extension EmptyTableCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.verticalEdges.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }

        selectionStyle = .none
        backgroundColor = .background
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileNoSettingCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: EmptyTableCell())
        }
    }
#endif
