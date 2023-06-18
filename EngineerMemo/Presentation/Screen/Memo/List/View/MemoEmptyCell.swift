import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoEmptyCell: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            UILabel().configure {
                $0.text = L10n.Memo.emptyDescription
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 14)
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }

            createButton.addConstraint {
                $0.width.equalTo(160)
                $0.height.equalTo(48)
            }
        }
    }

    private let createButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
        config.title = L10n.Components.Button.Do.create
        config.baseForegroundColor = .primary
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 16)
            return outgoing
        }
        config.background.backgroundColor = .grayButton
        config.background.cornerRadius = 8
        $0.configuration = config
    }

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

extension MemoEmptyCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - private methods

private extension MemoEmptyCell {
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
            WrapperView(view: MemoEmptyCell())
        }
    }
#endif
