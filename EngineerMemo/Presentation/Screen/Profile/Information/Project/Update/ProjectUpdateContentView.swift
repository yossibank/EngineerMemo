import Combine
import UIKit

// MARK: - properties & init

final class ProjectUpdateContentView: UIView {
    private(set) lazy var didChangeTitleInputPublisher = titleInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeStartDateInputPublisher = periodInputView.didChangeStartDatePublisher
    private(set) lazy var didChangeEndDateInputPublisher = periodInputView.didChangeEndDatePublisher
    private(set) lazy var didChangeRoleInputPublisher = roleInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeProcessInputPublisher = processInputView.didChangeProcessPublisher
    private(set) lazy var didChangeLanguageInputPublisher = languageInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeDatabaseInputPublisher = databaseInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeServerOSInputPublisher = serverOSInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeToolsInputPublisher = toolsInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeContentInputPublisher = contentInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(80)
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
            $0.setInputType(.init(
                title: L10n.Project.title,
                icon: Asset.projectTitle.image,
                placeholder: L10n.Project.Placeholder.title
            ))

            $0.setInputValue(project?.title)
        }

        periodInputView.configure {
            $0.setProjectValue(project)
        }

        roleInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.role,
                icon: Asset.projectRole.image,
                placeholder: L10n.Project.Placeholder.role
            ))

            $0.setInputValue(project?.role)
        }

        processInputView.configure {
            $0.setProcessValue(project?.processes ?? [])
        }

        languageInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.language,
                icon: Asset.projectLanguage.image,
                placeholder: L10n.Project.Placeholder.language
            ))

            $0.setInputValue(project?.language)
        }

        databaseInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.database,
                icon: Asset.projectDatabase.image,
                placeholder: L10n.Project.Placeholder.database
            ))

            $0.setInputValue(project?.database)
        }

        serverOSInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.serverOS,
                icon: Asset.projectServerOS.image,
                placeholder: L10n.Project.Placeholder.serverOS
            ))

            $0.setInputValue(project?.serverOS)
        }

        toolsInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.tools,
                icon: Asset.projectTools.image,
                placeholder: L10n.Project.Placeholder.tools
            ))

            $0.setInputValue(project?.tools.joined(separator: "、"))
        }

        contentInputView.configure {
            $0.setInputType(.init(
                title: L10n.Project.content,
                icon: Asset.projectContent.image,
                placeholder: L10n.Project.Placeholder.content
            ))

            $0.setInputValue(project?.content)
        }
    }

    private let titleInputView = UpdateTextInputView()
    private let periodInputView = ProjectUpdatePeriodInputView()
    private let roleInputView = UpdateTextInputView()
    private let processInputView = ProjectUpdateProcessInputView()
    private let languageInputView = UpdateTextInputView()
    private let databaseInputView = UpdateTextInputView()
    private let serverOSInputView = UpdateTextInputView()
    private let toolsInputView = UpdateTextInputView()
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
        gesturePublisher().weakSink(
            with: self,
            cancellables: &cancellables
        ) {
            $0.endEditing(true)
        }
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
            .weakSink(
                with: self,
                cancellables: &cancellables
            ) { instance in
                instance.barButton.apply(updatedButtonStyle)

                Task { @MainActor in
                    try await Task.sleep(seconds: 0.8)
                    instance.barButton.apply(defaultButtonStyle)
                }
            }
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
