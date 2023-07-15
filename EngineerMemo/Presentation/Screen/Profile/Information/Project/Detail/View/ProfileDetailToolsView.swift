import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileDetailToolsView: UIView {
    private var body: UIView {
        VStackView(spacing: 8) {
            HStackView(spacing: 8) {
                UIImageView()
                    .addConstraint {
                        $0.size.equalTo(24)
                    }
                    .configure {
                        $0.image = Asset.projectTools.image
                    }

                UILabel().configure {
                    $0.text = L10n.Project.tools
                    $0.textColor = .secondaryGray
                    $0.font = .boldSystemFont(ofSize: 16)
                }
            }

            BorderView().configure {
                $0.changeColor(.secondaryGray)
            }

            toolsView.configure {
                $0.axis = .vertical
                $0.spacing = 8
            }
        }
    }

    private let toolsView = UIStackView()

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

extension ProfileDetailToolsView {
    func configure(_ tools: [String]) {
        toolsView.subviews.forEach {
            toolsView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let labels = tools.map { tool in
            UILabel().configure {
                $0.text = tool
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
                $0.numberOfLines = 0
            }
        }

        labels.forEach {
            toolsView.addArrangedSubview($0)
        }
    }
}

// MARK: - private methods

private extension ProfileDetailToolsView {
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

    struct ProfileDetailToolsViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileDetailToolsView())
        }
    }
#endif
