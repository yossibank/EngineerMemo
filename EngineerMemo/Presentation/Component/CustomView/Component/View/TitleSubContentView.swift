import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleSubContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .leading, spacing: 8) {
            HStackView(spacing: 4) {
                titleLabel.configure {
                    $0.textColor = .secondaryGray
                    $0.font = .systemFont(ofSize: 14)
                }

                subTitleLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 12)
                    $0.numberOfLines = 0
                }
            }

            VStackView(spacing: 4) {
                contentLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.numberOfLines = 0
                }
            }
        }
    }

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
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

extension TitleSubContentView {
    func setTitle(title: String) {
        titleLabel.text = title
    }

    func setSubTitle(_ subTitle: String?) {
        subTitleLabel.text = subTitle.isNil ? nil : "(\(subTitle ?? .noSetting))"
    }

    func updateValue(_ text: String?) {
        contentLabel.text = text
    }
}

// MARK: - private methods

private extension TitleSubContentView {
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

    struct TitleSubContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleSubContentView()) {
                $0.setTitle(title: "title")
                $0.setSubTitle("subTitle")
                $0.updateValue("value")
            }
            .frame(height: 60)
        }
    }
#endif
