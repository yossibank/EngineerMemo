import Combine
import UIKit
import UIKitHelper

// MARK: - sheet content

struct SheetContent {
    let title: String?
    let message: String?
    let actions: [SheetAction]
}

// MARK: - sheet action

struct SheetAction {
    let title: String
    let actionType: SheetActionType
    let action: VoidBlock

    static var closeAction: SheetAction {
        .init(
            title: L10n.Sheet.close,
            actionType: .close,
            action: {}
        )
    }
}

enum SheetActionType {
    case `default`
    case warning
    case alert
    case close
}

// MARK: - properties & init

final class SheetContentView: UIView {
    private(set) lazy var didTapDismissPublisher = didTapDismissSubject.eraseToAnyPublisher()

    private var body: UIView {
        VStackView(
            spacing: 24,
            layoutMargins: .init(top: 16, left: 16, bottom: 8, right: 16)
        ) {
            VStackView(alignment: .center, spacing: 12) {
                titleLabel.configure {
                    $0.text = sheetContent.title
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 20)
                    $0.numberOfLines = 2
                }

                messageLabel.configure {
                    $0.text = sheetContent.message
                    $0.textColor = .primary
                    $0.font = .systemFont(ofSize: 14)
                    $0.numberOfLines = 3
                }
            }

            actionView
        }
        .configure {
            $0.backgroundColor = .sheet
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
    }

    private lazy var actionView = UIStackView().configure { view in
        view.axis = .vertical
        view.spacing = 12

        sheetContent.actions.forEach {
            view.addArrangedSubview(createButton($0))
        }
    }

    private var cancellables: Set<AnyCancellable> = .init()

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    private let didTapDismissSubject = PassthroughSubject<Void, Never>()
    private let sheetContent: SheetContent

    init(sheetContent: SheetContent) {
        self.sheetContent = sheetContent

        super.init(frame: .zero)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension SheetContentView {
    func createButton(_ sheetAction: SheetAction) -> UIButton {
        let button = UIButton(type: .system)
            .addConstraint {
                $0.height.equalTo(48)
            }
            .configure {
                var config = UIButton.Configuration.plain()
                config.title = sheetAction.title
                config.titleTextAttributesTransformer = .init { incoming in
                    var outgoing = incoming
                    outgoing.font = .boldSystemFont(ofSize: 16)
                    return outgoing
                }
                config.background.cornerRadius = 8

                switch sheetAction.actionType {
                case .default:
                    config.baseForegroundColor = .primary
                    config.background.backgroundColor = .background

                case .warning:
                    config.baseForegroundColor = .black
                    config.background.backgroundColor = .warning

                case .alert:
                    config.baseForegroundColor = .white
                    config.background.backgroundColor = .alert

                case .close:
                    config.baseForegroundColor = .primary
                    config.background.backgroundColor = .primaryGray
                }

                $0.configuration = config
            }

        button.publisher(for: .touchUpInside).sink { [weak self] _ in
            switch sheetAction.actionType {
            case .close:
                self?.didTapDismissSubject.send(())

            default:
                self?.didTapDismissSubject.send(())
                sheetAction.action()
            }
        }
        .store(in: &cancellables)

        return button
    }
}

// MARK: - protocol

extension SheetContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.bottom.leading.trailing.equalToSuperview()
            }

            $0.backgroundColor = .clear

            $0.gesturePublisher().sink { [weak self] _ in
                self?.didTapDismissSubject.send(())
            }
            .store(in: &cancellables)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SheetContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: SheetContentView(
                    sheetContent: .init(
                        title: "title",
                        message: "message",
                        actions: [
                            .init(
                                title: "Default",
                                actionType: .default,
                                action: {}
                            ),
                            .init(
                                title: "Warning",
                                actionType: .warning,
                                action: {}
                            ),
                            .init(
                                title: "Alert",
                                actionType: .alert,
                                action: {}
                            ),
                            .init(
                                title: "Close",
                                actionType: .close,
                                action: {}
                            )
                        ]
                    )
                )
            )
        }
    }
#endif
