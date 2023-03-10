#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - menu type

    extension UserDefaultsKey {
        enum DebugViewType {
            case dataHolderEnum(DataHolderEnumStructure)
            case textField(TextFieldStructure)

            struct DataHolderEnumStructure {
                let items: [String]
                let index: Int
                let description: String
            }

            struct TextFieldStructure {
                let description: String
            }
        }

        var debugViewType: DebugViewType {
            switch self {
            case .sample:
                return .dataHolderEnum(
                    .init(
                        items: DataHolder.Sample.allCases.map(\.description),
                        index: DataHolder.sample.rawValue,
                        description: DataHolder.sample.description
                    )
                )

            case .test:
                return .dataHolderEnum(
                    .init(
                        items: DataHolder.Test.allCases.map(\.description),
                        index: DataHolder.test.rawValue,
                        description: DataHolder.test.description
                    )
                )

            case .textField:
                return .textField(
                    .init(
                        description: DataHolder.textField.isEmpty
                            ? .noSetting
                            : DataHolder.textField
                    )
                )
            }
        }
    }

    // MARK: - properties & init

    final class DebugUserDefaultsContentView: UIView {
        private(set) lazy var didChangeSegmentIndexPublisher = didChangeSegmentIndexSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeInputTextPublisher = didChangeInputTextSubject.eraseToAnyPublisher()

        @Published private(set) var selectedKey: UserDefaultsKey = .sample

        private var cancellables: Set<AnyCancellable> = .init()

        private let menuButton = UIButton(type: .system)
            .apply(.debugMenuButton)
            .addConstraint {
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }

        private let contentView = UIView()

        private let didChangeSegmentIndexSubject = PassthroughSubject<Int, Never>()
        private let didChangeInputTextSubject = PassthroughSubject<String, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupMenu()
            setupContentView(key: .sample)
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
            if let userDefaultsEnumView = contentView.subviews.first as? DebugUserDefaultsEnumView {
                userDefaultsEnumView.updateDescription(description)
                return
            }

            if let userDefaultsTextView = contentView.subviews.first as? DebugUserDefaultsTextView {
                userDefaultsTextView.updateDescription(description)
                return
            }
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsContentView {
        func setupMenu() {
            var actions = [UIMenuElement]()

            UserDefaultsKey.allCases.forEach { key in
                actions.append(
                    UIAction(
                        title: key.rawValue,
                        state: key == selectedKey ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedKey = key
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
                $0.setTitle(selectedKey.rawValue, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }

        func setupContentView(key: UserDefaultsKey) {
            if !contentView.subviews.isEmpty {
                contentView.subviews.forEach {
                    $0.removeFromSuperview()
                }
            }

            switch key.debugViewType {
            case let .dataHolderEnum(data):
                let userDefaultsEnumView = DebugUserDefaultsEnumView()
                    .configure {
                        $0.updateSegment(items: data.items, index: data.index)
                        $0.updateDescription(data.description)
                        $0.segmentIndexPublisher.sink { [weak self] index in
                            self?.didChangeSegmentIndexSubject.send(index)
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsEnumView) {
                    $0.edges.equalToSuperview()
                }

            case let .textField(data):
                let userDefaultsTextView = DebugUserDefaultsTextView()
                    .configure {
                        $0.updateDescription(data.description)
                        $0.didChangeTextPublisher.sink { [weak self] text in
                            self?.didChangeInputTextSubject.send(text)
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsTextView) {
                    $0.edges.equalToSuperview()
                }
            }
        }

        func setupEvent() {
            $selectedKey
                .receive(on: DispatchQueue.main)
                .sink { [weak self] key in
                    self?.setupContentView(key: key)
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
                $0.centerY.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(24)
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
