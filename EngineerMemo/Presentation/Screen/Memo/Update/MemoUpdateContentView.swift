import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoUpdateContentView: UIView {
    @Published private(set) var selectedCategoryType: MemoInputCategoryType? {
        didSet {
            setupCategory()
        }
    }

    private(set) lazy var didChangeTitleTextPublisher = titleTextView.textDidChangePublisher
    private(set) lazy var didChangeContentTextPublisher = contentTextView.textDidChangePublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(spacing: 24) {
        VStackView(spacing: 12) {
            categoryView

            VStackView(spacing: 4) {
                categoryButton
                categoryBorderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }

        VStackView(spacing: 8) {
            titleView

            VStackView {
                titleTextView
                    .configure {
                        $0.font = .boldSystemFont(ofSize: 16)
                        $0.backgroundColor = .background
                        $0.isScrollEnabled = false
                        $0.delegate = self

                        if let modelObject {
                            $0.text = modelObject.title
                        }
                    }

                titleBorderView
            }
        }

        VStackView(spacing: 8) {
            contentView

            VStackView {
                contentTextView
                    .configure {
                        $0.font = .boldSystemFont(ofSize: 16)
                        $0.backgroundColor = .background
                        $0.isScrollEnabled = false
                        $0.delegate = self

                        if let modelObject {
                            $0.text = modelObject.content
                        }
                    }

                contentBorderView
            }
        }
    }

    private lazy var categoryView = createTitleView(.category)
    private lazy var titleView = createTitleView(.title)
    private lazy var contentView = createTitleView(.content)

    private let categoryButton = MenuButton(type: .system)
    private let categoryBorderView = BorderView()
    private let titleTextView = UITextView()
    private let titleBorderView = BorderView()
    private let contentTextView = UITextView()
    private let contentBorderView = BorderView()

    private var cancellables = Set<AnyCancellable>()

    private let modelObject: MemoModelObject?

    init(modelObject: MemoModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupMenu()
        setupBarButton()
        setupEvent()
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

            [barButton, categoryView, titleView, contentView].forEach {
                $0.layer.borderColor = UIColor.primary.cgColor
            }
        }
    }
}

// MARK: - internal methods

extension MemoUpdateContentView {
    func configureBarButton(isEnabled: Bool) {
        barButton.isEnabled = isEnabled
        barButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

// MARK: - private methods

private extension MemoUpdateContentView {
    func setupMenu() {
        guard let category = modelObject?.category else {
            selectedCategoryType = .noSetting
            return
        }

        switch category {
        case .todo:
            selectedCategoryType = .todo

        case .technical:
            selectedCategoryType = .technical

        case .interview:
            selectedCategoryType = .interview

        case .event:
            selectedCategoryType = .event

        case .tax:
            selectedCategoryType = .tax

        case .other:
            selectedCategoryType = .other
        }
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

    func setupCategory() {
        var actions = [UIMenuElement]()

        MemoInputCategoryType.allCases.forEach { categoryType in
            actions.append(
                UIAction(
                    title: categoryType.title,
                    image: categoryType.image,
                    state: categoryType == selectedCategoryType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedCategoryType = categoryType
                    }
                )
            )
        }

        categoryButton.configure {
            var config = UIButton.Configuration.filled()
            config.title = selectedCategoryType?.title
            config.image = selectedCategoryType?.image?
                .resized(size: .init(width: 24, height: 24))
                .withRenderingMode(.alwaysOriginal)
            config.baseForegroundColor = .primary
            config.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
            config.imagePadding = 8
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 16)
                return outgoing
            }
            config.background.backgroundColor = .background
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
            $0.showsMenuAsPrimaryAction = true
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
        }

        categoryButton.$isShowMenu.sink { [weak self] isShow in
            self?.categoryBorderView.changeColor(isShow ? .inputBorder : .primary)
        }
        .store(in: &cancellables)
    }

    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }

    func createTitleView(_ type: MemoContentType) -> UIView {
        let titleStackView = HStackView(spacing: 4) {
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

        return UIView()
            .addSubview(titleStackView) {
                $0.edges.equalToSuperview().inset(8)
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
            .apply(.inputView)
    }
}

// MARK: - delegate

extension MemoUpdateContentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === titleTextView {
            titleBorderView.changeColor(.inputBorder)
        }

        if textView === contentTextView {
            contentBorderView.changeColor(.inputBorder)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === titleTextView {
            titleBorderView.changeColor(.primary)
        }

        if textView === contentTextView {
            contentBorderView.changeColor(.primary)
        }
    }
}

// MARK: - protocol

extension MemoUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.bottom.equalToSuperview().priority(.low)
                $0.leading.trailing.equalToSuperview().inset(16)
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
