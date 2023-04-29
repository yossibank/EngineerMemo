import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoListHeaderView: UICollectionReusableView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var button1Publisher = button1.publisher(for: .touchUpInside)
    private(set) lazy var button2Publisher = button2.publisher(for: .touchUpInside)
    private(set) lazy var button3Publisher = button3.publisher(for: .touchUpInside)

    private var body: UIView {
        HStackView(alignment: .center, spacing: 8) {
            button1.configure {
                $0.setTitle(
                    "1",
                    for: .normal
                )
                $0.setTitleColor(
                    .primary,
                    for: .normal
                )
                $0.clipsToBounds = true
                $0.layer.borderColor = UIColor.primary.cgColor
                $0.layer.borderWidth = 1.0
                $0.layer.cornerRadius = 4
            }

            button2.configure {
                $0.setTitle(
                    "2",
                    for: .normal
                )
                $0.setTitleColor(
                    .primary,
                    for: .normal
                )
                $0.clipsToBounds = true
                $0.layer.borderColor = UIColor.primary.cgColor
                $0.layer.borderWidth = 1.0
                $0.layer.cornerRadius = 4
            }

            button3.configure {
                $0.setTitle(
                    "3",
                    for: .normal
                )
                $0.setTitleColor(
                    .primary,
                    for: .normal
                )
                $0.clipsToBounds = true
                $0.layer.borderColor = UIColor.primary.cgColor
                $0.layer.borderWidth = 1.0
                $0.layer.cornerRadius = 4
            }

            UIView()
        }
    }

    private let button1 = UIButton(type: .system)
    private let button2 = UIButton(type: .system)
    private let button3 = UIButton(type: .system)

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [button1, button2, button3].forEach {
                $0.layer.borderColor = UIColor.primary.cgColor
            }
        }
    }
}

// MARK: - private methods

private extension MemoListHeaderView {
    func setupView() {
        configure {
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

    struct MemoListHeaderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoListHeaderView())
                .frame(height: 40)
        }
    }
#endif
