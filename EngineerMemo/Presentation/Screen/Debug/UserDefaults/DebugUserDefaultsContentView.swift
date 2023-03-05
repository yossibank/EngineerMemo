#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - menu type

    enum DebugUserDefaultsMenuType: String, CaseIterable {
        case sample
        case test

        var items: [String] {
            switch self {
            case .sample: return DataHolder.Sample.allCases.map(\.description)
            case .test: return DataHolder.Test.allCases.map(\.description)
            }
        }

        var index: Int {
            switch self {
            case .sample: return DataHolder.sample.rawValue
            case .test: return DataHolder.test.rawValue
            }
        }

        var description: String {
            switch self {
            case .sample: return DataHolder.sample.description
            case .test: return DataHolder.test.description
            }
        }
    }

    // MARK: - properties & init

    final class DebugUserDefaultsContentView: UIView {
        private(set) lazy var selectedIndexPublisher = selectedIndexSubject.eraseToAnyPublisher()

        @Published private(set) var selectedType: DebugUserDefaultsMenuType = .sample

        private var cancellables: Set<AnyCancellable> = .init()

        private let menuButton = UIButton(type: .system)
            .apply(.debugMenuButton)
            .addConstraint {
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }

        private let contentView = UIView()

        private let selectedIndexSubject = PassthroughSubject<Int, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupMenu()
            setupContentView(menuType: .sample)
            setupEvent()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }

    // MARK: - internal methods

    extension DebugUserDefaultsContentView {
        func updateEnumView(description: String) {
            guard let userDefaultsEnumView = contentView.subviews.first as? DebugUserDefaultsEnumView else {
                return
            }

            userDefaultsEnumView.updateDescription(description)
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsContentView {
        func setupMenu() {
            var actions = [UIMenuElement]()

            DebugUserDefaultsMenuType.allCases.forEach { type in
                actions.append(
                    UIAction(
                        title: type.rawValue,
                        state: type == selectedType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedType = type
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.configure {
                $0.menu = .init(
                    title: .empty,
                    options: .displayInline,
                    children: actions
                )
                $0.setTitle(selectedType.rawValue, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }

        func setupContentView(menuType: DebugUserDefaultsMenuType) {
            if !contentView.subviews.isEmpty {
                contentView.subviews.forEach {
                    $0.removeFromSuperview()
                }
            }

            let userDefaultsEnumView = DebugUserDefaultsEnumView()
                .configure {
                    $0.updateSegment(items: menuType.items, index: menuType.index)
                    $0.updateDescription(menuType.description)
                    $0.segmentIndexPublisher.sink { [weak self] index in
                        self?.selectedIndexSubject.send(index)
                    }
                    .store(in: &cancellables)
                }

            contentView.addSubview(userDefaultsEnumView) {
                $0.edges.equalToSuperview()
            }
        }

        func setupEvent() {
            $selectedType
                .receive(on: DispatchQueue.main)
                .sink { [weak self] menuType in
                    self?.setupContentView(menuType: menuType)
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugUserDefaultsContentView: ContentView {
        func setupView() {
            backgroundColor = .primary

            addSubview(menuButton) {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(72)
                $0.centerX.equalToSuperview()
            }

            addSubview(contentView) {
                $0.center.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugUserDefaultsContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugUserDefaultsContentView()
            )
        }
    }
#endif
