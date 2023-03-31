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
            case bool(BoolStructure)
            case date(DateStructure)
            case array(ArrayStructure)

            struct DataHolderEnumStructure {
                let items: [String]
                let index: Int
                let description: String
            }

            struct TextFieldStructure {
                let isOptional: Bool
                let description: String
            }

            struct BoolStructure {
                let isOptional: Bool
                let index: Int
                let description: String
            }

            struct DateStructure {
                let isOptional: Bool
                let description: String
            }

            struct ArrayStructure {
                let description: String
            }
        }

        var debugViewType: DebugViewType {
            switch self {
            case .profileIcon, .sample:
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

            case .string:
                return .textField(
                    .init(
                        isOptional: false,
                        description: DataHolder.string.isEmpty ? .emptyWord : DataHolder.string
                    )
                )

            case .int:
                return .textField(
                    .init(
                        isOptional: false,
                        description: DataHolder.int.description
                    )
                )

            case .bool:
                return .bool(
                    .init(
                        isOptional: false,
                        index: DataHolder.bool.boolValue,
                        description: DataHolder.bool.description
                    )
                )

            case .date:
                return .date(
                    .init(
                        isOptional: false,
                        description: DataHolder.date.toString
                    )
                )

            case .array:
                return .array(
                    .init(description: DataHolder.array.joined(separator: ", "))
                )

            case .optional:
                return .textField(
                    .init(
                        isOptional: true,
                        description: DataHolder.optional?.description ?? .nilWord
                    )
                )

            case .optionalBool:
                return .bool(
                    .init(
                        isOptional: true,
                        index: DataHolder.optionalBool?.boolValue ?? .nilIndex,
                        description: DataHolder.optionalBool?.description ?? .nilWord
                    )
                )
            }
        }
    }

    // MARK: - properties & init

    final class DebugUserDefaultsContentView: UIView {
        private(set) lazy var didChangeSegmentIndexPublisher = didChangeSegmentIndexSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeInputTextPublisher = didChangeInputTextSubject.eraseToAnyPublisher()
        private(set) lazy var didChangeInputDatePublisher = didChangeInputDateSubject.eraseToAnyPublisher()
        private(set) lazy var didTapAddButtonPublisher = didTapAddButtonSubject.eraseToAnyPublisher()
        private(set) lazy var didTapDeleteButtonPublisher = didTapDeleteButtonSubject.eraseToAnyPublisher()
        private(set) lazy var didTapNilButtonPublisher = didTapNilButtonSubject.eraseToAnyPublisher()

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
        private let didChangeInputDateSubject = PassthroughSubject<Date, Never>()
        private let didTapAddButtonSubject = PassthroughSubject<String, Never>()
        private let didTapDeleteButtonSubject = PassthroughSubject<String, Never>()
        private let didTapNilButtonSubject = PassthroughSubject<Void, Never>()

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
        func updateDescription(description: String) {
            if let userDefaultsEnumView = contentView.subviews.first as? DebugUserDefaultsEnumView {
                userDefaultsEnumView.updateDescription(description)
                return
            }

            if let userDefaultsTextView = contentView.subviews.first as? DebugUserDefaultsTextView {
                userDefaultsTextView.updateDescription(description)
                return
            }

            if let userDefaultsBoolView = contentView.subviews.first as? DebugUserDefaultsBoolView {
                userDefaultsBoolView.updateDescription(description)
                return
            }

            if let userDefaultsDateView = contentView.subviews.first as? DebugUserDefaultsDateView {
                userDefaultsDateView.updateDescription(description)
                return
            }

            if let userDefaultsArrayView = contentView.subviews.first as? DebugUserDefaultsArrayView {
                userDefaultsArrayView.updateDescription(description)
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
                        $0.configureNilButton(data.isOptional)
                        $0.updateDescription(data.description)

                        $0.didChangeInputTextPublisher.sink { [weak self] text in
                            self?.didChangeInputTextSubject.send(text)
                        }
                        .store(in: &cancellables)

                        $0.didTapNilButtonPublisher.sink { [weak self] _ in
                            self?.didTapNilButtonSubject.send(())
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsTextView) {
                    $0.edges.equalToSuperview()
                }

            case let .bool(data):
                let userDefaultsBoolView = DebugUserDefaultsBoolView()
                    .configure {
                        $0.configureNilSegment(data.isOptional)
                        $0.updateSegment(index: data.index)
                        $0.updateDescription(data.description)

                        $0.segmentIndexPublisher.sink { [weak self] index in
                            self?.didChangeSegmentIndexSubject.send(index)
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsBoolView) {
                    $0.edges.equalToSuperview()
                }

            case let .date(data):
                let userDefaultsDateView = DebugUserDefaultsDateView()
                    .configure {
                        $0.configureNilButton(data.isOptional)
                        $0.updateDescription(data.description)

                        $0.didChangeInputDatePublisher.sink { [weak self] date in
                            self?.didChangeInputDateSubject.send(date)
                        }
                        .store(in: &cancellables)

                        $0.didTapNilButtonPublisher.sink { [weak self] _ in
                            self?.didTapNilButtonSubject.send(())
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsDateView) {
                    $0.edges.equalToSuperview()
                }

            case let .array(data):
                let userDefaultsArrayView = DebugUserDefaultsArrayView()
                    .configure {
                        $0.updateDescription(data.description)

                        $0.didTapAddButtonPublisher.sink { [weak self] text in
                            self?.didTapAddButtonSubject.send(text)
                        }
                        .store(in: &cancellables)

                        $0.didTapDeleteButtonPublisher.sink { [weak self] text in
                            self?.didTapDeleteButtonSubject.send(text)
                        }
                        .store(in: &cancellables)
                    }

                contentView.addSubview(userDefaultsArrayView) {
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
            configure {
                $0.backgroundColor = .primary
            }

            addSubview(menuButton) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(72)
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
