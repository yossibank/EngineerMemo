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
