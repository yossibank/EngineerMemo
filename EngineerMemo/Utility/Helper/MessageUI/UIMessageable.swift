import MessageUI

struct UIMessage {
    let subject: String
    let body: String
    let delegate: MFMailComposeViewControllerDelegate?
}

protocol UIMessageable: UIViewController {}

extension UIMessageable {
    func openMessage(_ message: UIMessage) {
        guard MFMailComposeViewController.canSendMail() else {
            showActionSheet(messageResult: .noSetting)
            return
        }

        present(
            MFMailComposeViewController().configure {
                $0.mailComposeDelegate = message.delegate
                $0.setSubject(message.subject)
                $0.setToRecipients([AppConfig.appInquiryAddress])
                $0.setMessageBody(message.body, isHTML: false)
            },
            animated: true
        )
    }
}

extension UIViewController {
    enum UIMessageResult {
        case cancelled
        case saved
        case send
        case failed
        case noSetting

        var title: String {
            switch self {
            case .cancelled: l10n.Title.cancel
            case .saved: l10n.Title.draftSave
            case .send: l10n.Title.success
            case .failed: l10n.Title.error
            case .noSetting: l10n.Title.error
            }
        }

        var message: String {
            switch self {
            case .cancelled: l10n.Message.cancelledMail
            case .saved: l10n.Message.savedMail
            case .send: l10n.Message.successSendMail
            case .failed: l10n.Message.failedSendMail
            case .noSetting: l10n.Message.noSettingMailAccount
            }
        }

        var actions: [SheetAction] {
            switch self {
            case .noSetting:
                [.init(
                    title: l10n.Action.setting,
                    actionType: .default
                ) {
                    AppOpen.appMail()
                }]

            default:
                []
            }
        }

        private var l10n: L10n.Sheet.Type {
            L10n.Sheet.self
        }
    }
}

extension UIViewController {
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
