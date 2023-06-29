import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectDetailCell: UITableViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            titleStackView
            contentStackView
        }
    }

    private lazy var titleStackView = createStackView(.title)
    private lazy var contentStackView = createStackView(.content)

    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

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

// MARK: - internal methods

extension ProjectDetailCell {
    func configure(_ modelObject: ProjectModelObject) {
        titleLabel.text = modelObject.title
        contentLabel.text = modelObject.content
    }
}

// MARK: - private methods

private extension ProjectDetailCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }

    func createStackView(_ type: ProjectContentType) -> UIStackView {
        let valueLabel: UILabel

        switch type {
        case .title:
            valueLabel = titleLabel

        case .content:
            valueLabel = contentLabel
        }

        let contentView: UIView = valueLabel.configure {
            $0.textColor = .primary
            $0.font = .boldSystemFont(ofSize: 16)
            $0.numberOfLines = 0
        }

        return VStackView(spacing: 8) {
            HStackView(spacing: 4) {
                UIImageView()
                    .addConstraint {
                        $0.size.equalTo(24)
                    }
                    .configure {
                        $0.image = type.image
                    }

                UILabel().configure {
                    $0.text = type.title
                    $0.textColor = .secondaryGray
                    $0.font = .boldSystemFont(ofSize: 16)
                }

                UIView()
            }

            BorderView().configure {
                $0.changeColor(.secondaryGray)
            }

            contentView
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectDetailCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectDetailCell())
        }
    }
#endif
