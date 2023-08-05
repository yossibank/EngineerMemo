import Combine
import UIKit

// MARK: - properties & init

final class TitleHeaderView: UICollectionReusableView {
    private var body: UIView {
        VStackView {
            titleLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 12)
            }
        }
    }

    private let titleLabel = UILabel()

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

extension TitleHeaderView {
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - private methods

private extension TitleHeaderView {
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

    struct TitleHeaderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleHeaderView())
        }
    }
#endif
