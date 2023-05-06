import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoUpdateContentView: UIView {
    private(set) lazy var didChangeTitleTextPublisher = titleTextView.textDidChangePublisher
    private(set) lazy var didChangeContentTextPublisher = contentTextView.textDidChangePublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    @Published private(set) var selectedCategoryType: MemoInputCategoryType? {
        didSet {
            setupCategory()
        }
    }

    private var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(spacing: 16) {
            VStackView(spacing: 8) {
                categoryLabelView

                categoryButton.addConstraint {
                    $0.height.equalTo(48)
                }
            }

            VStackView(spacing: 8) {
                titleLabelView

                titleTextView
                    .addConstraint {
                        $0.height.equalTo(48)
                    }
                    .configure {
                        $0.font = .boldSystemFont(ofSize: 16)
                        $0.backgroundColor = .background
                        $0.layer.borderColor = UIColor.primary.cgColor
                        $0.layer.borderWidth = 1.0
                        $0.layer.cornerRadius = 4

                        if let modelObject {
                            $0.text = modelObject.title
                        }
                    }
            }

            VStackView(spacing: 8) {
                contentLabelView

                contentTextView
                    .addConstraint {
                        $0.height.equalTo(120)
                    }
                    .configure {
                        $0.font = .boldSystemFont(ofSize: 14)
                        $0.backgroundColor = .background
                        $0.layer.borderColor = UIColor.primary.cgColor
                        $0.layer.borderWidth = 1.0
                        $0.layer.cornerRadius = 4

                        if let modelObject {
                            $0.text = modelObject.content
                        }
                    }
            }
        }
    }

    private lazy var categoryLabelView = createLabelView(.category)
    private lazy var titleLabelView = createLabelView(.title)
    private lazy var contentLabelView = createLabelView(.content)

    private let categoryView = UIView()
    private let categoryLabel = UILabel()
    private let categoryButton = UIButton(type: .system)
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let titleTextView = UITextView()
    private let contentView = UIView()
    private let contentLabel = UILabel()
    private let contentTextView = UITextView()

    private let modelObject: MemoModelObject?

    init(modelObject: MemoModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupMenu()
        setupBarButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [barButton, categoryView, titleView, titleTextView, contentView, contentTextView].forEach {
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

        case .other:
            selectedCategoryType = .other
        }
    }

    func setupBarButton() {
        let defaultButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .createNavigationButton
            : .updateNavigationButton

        let updatedButtonStyle: ViewStyle<UIButton> = modelObject == nil
            ? .createDoneNavigationButton
            : .updateDoneNavigationButton

        barButton.apply(defaultButtonStyle)

        barButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.barButton.apply(updatedButtonStyle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
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
            config.background.cornerRadius = 4
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
            $0.showsMenuAsPrimaryAction = true
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
        }
    }

    func createLabelView(_ type: MemoContentType) -> UIView {
        let labelView: UIView
        let valueLabel: UILabel

        switch type {
        case .category:
            labelView = categoryView
            valueLabel = categoryLabel

        case .title:
            labelView = titleView
            valueLabel = titleLabel

        case .content:
            labelView = contentView
            valueLabel = contentLabel
        }

        valueLabel.configure {
            $0.text = type.title
            $0.textColor = .secondaryGray
            $0.font = .boldSystemFont(ofSize: 16)
        }

        return VStackView {
            labelView
                .addSubview(valueLabel) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)
        }
    }
}

// MARK: - protocol

extension MemoUpdateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
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
