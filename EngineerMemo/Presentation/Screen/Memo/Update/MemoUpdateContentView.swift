import Combine
import UIKit

// MARK: - properties & init

final class MemoUpdateContentView: UIView {
    private(set) lazy var didChangeCategoryPublisher = categoryInputView.$selectedCategoryType
    private(set) lazy var didChangeTitleTextPublisher = titleInputView.didChangeInputTextPublisher
    private(set) lazy var didChangeContentTextPublisher = contentInputView.didChangeInputTextPublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(80)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(spacing: 16) {
        categoryInputView.configure {
            $0.setCategoryMenu(modelObject)
        }

        titleInputView.configure {
            $0.setInputType(.init(
                title: L10n.Memo.title,
                icon: Asset.memoTitle.image,
                placeholder: L10n.Memo.Example.title
            ))

            $0.setInputValue(modelObject?.title)
        }

        contentInputView.configure {
            $0.setInputType(.init(
                title: L10n.Memo.content,
                icon: Asset.memoContent.image,
                placeholder: L10n.Memo.Example.content
            ))

            $0.setInputValue(modelObject?.content)
        }
    }

    private let categoryInputView = UpdateMenuInputView(.category)
    private let titleInputView = UpdateTextMultiInputView()
    private let contentInputView = UpdateTextMultiInputView()

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: MemoModelObject?

    init(modelObject: MemoModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
        setupBarButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension MemoUpdateContentView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            barButton.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension MemoUpdateContentView {
    func configureEnableButton(isEnabled: Bool) {
        barButton.isEnabled = isEnabled
        barButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

// MARK: - private methods

private extension MemoUpdateContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func setupBarButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject.isNil
            ? .createNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject.isNil
            ? .createDoneNavigationButton
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

extension MemoUpdateContentView: ContentView {
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

    struct MemoCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoUpdateContentView(modelObject: nil))
        }
    }
#endif
