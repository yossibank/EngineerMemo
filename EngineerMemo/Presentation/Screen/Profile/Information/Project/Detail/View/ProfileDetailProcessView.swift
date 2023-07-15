import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileDetailProcessView: UIView {
    typealias Process = ProjectModelObject.Process

    private var body: UIView {
        VStackView(spacing: 8) {
            HStackView(spacing: 8) {
                UIImageView()
                    .addConstraint {
                        $0.size.equalTo(24)
                    }
                    .configure {
                        $0.image = Asset.projectProcess.image
                    }

                UILabel().configure {
                    $0.text = L10n.Project.process
                    $0.textColor = .secondaryGray
                    $0.font = .boldSystemFont(ofSize: 16)
                }
            }

            BorderView().configure {
                $0.changeColor(.secondaryGray)
            }

            processBaseView.configure {
                $0.axis = .vertical
                $0.spacing = 8
            }
        }
    }

    private lazy var processBaseView = UIStackView(
        arrangedSubviews: Process.allCases.map { ProjectUpdateProcessView($0) }
    )

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

extension ProfileDetailProcessView {
    func configure(_ processes: [Process]) {
        processBaseView.subviews
            .compactMap { $0 as? ProjectUpdateProcessView }
            .forEach { $0.updateImage(processes) }
    }
}

// MARK: - private methods

private extension ProfileDetailProcessView {
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

    struct ProfileDetailProcessViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileDetailProcessView())
        }
    }
#endif
