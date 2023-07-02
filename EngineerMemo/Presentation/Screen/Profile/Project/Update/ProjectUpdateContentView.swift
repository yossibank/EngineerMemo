import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectUpdateContentView: UIView {
    private(set) lazy var didChangeTitleInputPublisher = titleInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeStartDateInputPublisher = periodInputView.didChangeStartDatePublisher
    private(set) lazy var didChangeEndDateInputPublisher = periodInputView.didChangeEndDatePublisher
    private(set) lazy var didChangeRoleInputPublisher = roleInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeContentInputPublisher = contentInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(
        distribution: .equalSpacing,
        spacing: 16
    ) {
        titleInputView.configure {
            $0.inputValue(.init(
                title: L10n.Project.title,
                icon: Asset.projectTitle.image,
                placeholder: L10n.Project.Placeholder.title
            ))

            $0.updateValue(project?.title)
        }

        periodInputView.configure {
            $0.updateValue(project)
        }

        roleInputView.configure {
            $0.inputValue(.init(
                title: L10n.Project.role,
                icon: Asset.projectRole.image,
                placeholder: L10n.Project.Placeholder.role
            ))

            $0.updateValue(project?.role)
        }

        contentInputView.configure {
            $0.inputValue(.init(
                title: L10n.Project.content,
                icon: Asset.projectContent.image,
                placeholder: L10n.Project.Placeholder.content
            ))

            $0.updateValue(project?.content)
        }
    }

    private let titleInputView = UpdateTextInputView()
    private let periodInputView = ProjectUpdatePeriodInputView()
    private let roleInputView = UpdateTextInputView()
    private let contentInputView = UpdateTextMultiInputView()

    private var project: ProjectModelObject? {
        modelObject.projects
            .filter { $0.identifier == identifier }
            .first
    }

    private var cancellables = Set<AnyCancellable>()

    private let identifier: String
    private let modelObject: ProfileModelObject

    init(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        self.identifier = identifier
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProjectUpdateContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - private methods

private extension ProjectUpdateContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func setupButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = project.isNil
            ? .settingNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = project.isNil
            ? .settingDoneNavigationButton
            : .updateDoneNavigationButton

        barButton.apply(defaultButtonStyle)

        barButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.barButton.apply(updatedButtonStyle)

                Task { @MainActor in
                    try await Task.sleep(seconds: 0.8)
                    self?.barButton.apply(defaultButtonStyle)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - protocol

extension ProjectUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.bottom.equalToSuperview().priority(.low)
                $0.horizontalEdges.equalToSuperview()
            }

            $0.keyboardLayoutGuide.snp.makeConstraints {
                $0.top.equalTo(scrollView.snp.bottom).inset(-16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProjectUpdateContentView(
                    identifier: "identifier",
                    modelObject: ProfileModelObjectBuilder().build()
                )
            )
        }
    }
#endif