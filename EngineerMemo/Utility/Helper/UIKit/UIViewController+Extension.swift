import UIKit

extension UIViewController {
    enum UIMessageResult {
        case cancelled
        case saved
        case send
        case failed
        case noSetting

        var title: String {
            switch self {
            case .cancelled: return l10n.Title.cancel
            case .saved: return l10n.Title.draftSave
            case .send: return l10n.Title.success
            case .failed: return l10n.Title.error
            case .noSetting: return l10n.Title.error
            }
        }

        var message: String {
            switch self {
            case .cancelled: return l10n.Message.cancelledMail
            case .saved: return l10n.Message.savedMail
            case .send: return l10n.Message.successSendMail
            case .failed: return l10n.Message.failedSendMail
            case .noSetting: return l10n.Message.noSettingMailAccount
            }
        }

        var actions: [SheetAction] {
            switch self {
            case .noSetting:
                return [
                    .init(
                        title: l10n.Action.setting,
                        actionType: .default
                    ) {
                        AppConfig.openMailApp()
                    }
                ]

            default:
                return []
            }
        }

        private var l10n: L10n.Sheet.Type {
            L10n.Sheet.self
        }
    }

    func showActionSheet(
        title: String? = nil,
        message: String? = nil,
        actions: [SheetAction] = []
    ) {
        navigationController?.definesPresentationContext = false

        var actions = actions
        actions.append(.closeAction)

        present(
            AppControllers.Sheet(
                .init(
                    title: title,
                    message: message,
                    actions: actions
                )
            ),
            animated: true
        )
    }

    func showActionSheet(messageResult: UIMessageResult) {
        navigationController?.definesPresentationContext = false

        var actions = messageResult.actions
        actions.append(.closeAction)

        present(
            AppControllers.Sheet(
                .init(
                    title: messageResult.title,
                    message: messageResult.message,
                    actions: actions
                )
            ),
            animated: true
        )
    }
}
