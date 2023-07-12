import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectUpdateProcessInputView: UIView {
    typealias Process = ProjectModelObject.Process

    private(set) lazy var didChangeProcessPublisher = didChangeProcessSubject.eraseToAnyPublisher()

    private var body: UIView {
        VStackView(spacing: 8) {
            UpdateTitleView().configure {
                $0.inputValue(
                    title: L10n.Project.process,
                    icon: Asset.projectProcess.image
                )
            }

            processView

            HStackView {
                UIView()

                UILabel().configure {
                    $0.text = L10n.Project.processHint
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 11)
                    $0.numberOfLines = 1
                }
            }
        }
    }

    private lazy var processView: UIView = {
        let views = Process.allCases.map { process in
            let view = ProjectUpdateProcessView(process)

            view.didTapViewPublisher.sink { [weak self] _ in
                guard let self else {
                    return
                }

                if didChangeProcessSubject.value.contains(process) {
                    didChangeProcessSubject.value.removeAll { $0 == process }
                } else {
                    didChangeProcessSubject.value.append(process)
                }

                view.updateImage(didChangeProcessSubject.value)
            }
            .store(in: &cancellables)

            return view
        }

        return UIStackView(arrangedSubviews: views).configure {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }()

    private let didChangeProcessSubject = CurrentValueSubject<[Process], Never>([])

    private var cancellables = Set<AnyCancellable>()

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

extension ProjectUpdateProcessInputView {
    func updateValue(_ processes: [Process]) {
        didChangeProcessSubject.value.append(contentsOf: processes)

        processView.subviews
            .compactMap { $0 as? ProjectUpdateProcessView }
            .forEach { $0.updateImage(processes) }
    }
}

// MARK: - private methods

private extension ProjectUpdateProcessInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectUpdateProcessInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectUpdateProcessInputView())
        }
    }
#endif
