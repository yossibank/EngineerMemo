import Combine
import MessageUI

// MARK: - inject

extension SettingViewController: VCInjectable {
    typealias CV = SettingContentView
    typealias VM = SettingViewModel
}

// MARK: - properties & init

final class SettingViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension SettingViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToView()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension SettingViewController {
    func bindToView() {
        viewModel.output.$didTapReview
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                AppOpen.appReview()
            }
            .store(in: &cancellables)

        viewModel.output.$didTapInquiry
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                openMessage(
                    .init(
                        subject: L10n.Mail.subject,
                        body: L10n.Mail.body,
                        delegate: self
                    )
                )
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didChangeColorThemeIndexPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didChangeColorThemeIndex.send($0)
            }
            .store(in: &cancellables)

        contentView.didTapApplicationCellPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapApplicationCell.send($0)
            }
            .store(in: &cancellables)
    }
}

// MARK: - protocol

extension SettingViewController: UIMessageable, MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self else {
                return
            }

            switch result {
            case .cancelled:
                showActionSheet(messageResult: .cancelled)

            case .saved:
                showActionSheet(messageResult: .saved)

            case .sent:
                showActionSheet(messageResult: .send)

            case .failed:
                showActionSheet(messageResult: .failed)

            @unknown default:
                break
            }
        }
    }
}
