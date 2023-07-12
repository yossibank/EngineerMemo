import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectUpdateProcessView: UIView {
    typealias Process = ProjectModelObject.Process

    private(set) lazy var didTapViewPublisher = gesturePublisher().eraseToAnyPublisher()

    private var body: UIView {
        HStackView(alignment: .center, layoutMargins: .init(.horizontal, 8)) {
            processLabel.configure {
                $0.text = process.value
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 13)
                $0.numberOfLines = 1
            }

            UIView()

            imageView
        }
        .apply(.inputView)
    }

    private let processLabel = UILabel()
    private let imageView = UIImageView()

    private let process: Process

    init(_ process: Process) {
        self.process = process

        super.init(frame: .zero)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ProjectUpdateProcessView {
    func updateImage(_ processes: [Process]) {
        let processImage = processes.contains(process)
            ? Asset.checkmark.image
            : Asset.noCheck.image

        imageView.image = processImage
            .resized(size: .init(width: 16, height: 16))
            .withRenderingMode(.alwaysOriginal)
    }
}

// MARK: - private methods

private extension ProjectUpdateProcessView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
                $0.height.equalTo(28)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectUpdateProcessViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectUpdateProcessView(.implementation)) {
                $0.updateImage([.implementation])
            }
        }
    }
#endif
