import Combine
import UIKit

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

        viewModel.input.viewDidLoad.send(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - internal methods

extension SettingViewController {}

// MARK: - private methods

private extension SettingViewController {}
