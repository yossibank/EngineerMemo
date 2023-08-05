#if DEBUG
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugProjectListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }
            .addSubview(iconImageView) {
                $0.top.trailing.equalToSuperview().inset(12)
                $0.size.equalTo(60)
            }
            .configure {
                $0.backgroundColor = .primaryGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }

        private var body: UIView {
            VStackView(spacing: 16) {
                VStackView(alignment: .center) {
                    UILabel().configure {
                        $0.text = L10n.Profile.project
                        $0.font = .boldSystemFont(ofSize: 16)
                    }
                }

                VStackView(alignment: .leading, spacing: 16) {
                    nameView.configure {
                        $0.setTitle(title: L10n.Profile.name)
                    }

                    projectCountView.configure {
                        $0.setTitle(title: L10n.Project.count)
                    }

                    titleView.configure {
                        $0.setTitle(title: L10n.Project.title)
                    }

                    contentsView.configure {
                        $0.setTitle(title: L10n.Project.content)
                    }
                }
            }
        }

        private let iconImageView = UIImageView().configure {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 30
        }

        private let nameView = TitleContentView()
        private let projectCountView = TitleContentView()
        private let titleView = TitleContentView()
        private let contentsView = TitleContentView()

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

    extension DebugProjectListCell {
        func configure(_ modelObject: ProfileModelObject) {
            nameView.setContent(modelObject.name)
            projectCountView.setContent(L10n.Project.number(modelObject.projects.count))

            if let project = modelObject.projects.first {
                titleView.setContent(project.title ?? .noSetting)
                contentsView.setContent(project.content ?? .noSetting)
            }

            if let data = modelObject.iconImage,
               let image = UIImage(data: data) {
                iconImageView.image = image
            } else {
                iconImageView.image = Asset.penguin.image
            }
        }
    }

    // MARK: - private methods

    private extension DebugProjectListCell {
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

    struct DebugProjectListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProjectListCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
