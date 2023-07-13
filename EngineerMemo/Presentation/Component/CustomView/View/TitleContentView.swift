import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .leading, spacing: 8) {
            titleLabel.configure {
                $0.textColor = .secondaryGray
                $0.font = .systemFont(ofSize: 14)
            }

            contentLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
                $0.numberOfLines = 0
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
}

// MARK: - internal methods

extension TitleContentView {
    func setTitle(title: String) {
        titleLabel.text = title
    }

    func setContent(_ text: String?) {
        contentLabel.text = text
    }

    func setContentLine(_ line: Int) {
        contentLabel.numberOfLines = line
    }
}

// MARK: - private methods

private extension TitleContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct TitleContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleContentView()) {
                $0.setTitle(title: "title")
                $0.setContent("value")
            }
            .frame(height: 40)
        }
    }
#endif
