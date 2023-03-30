import Combine
import UIKit

// MARK: - inject

extension ProfileIconViewController: VCInjectable {
    typealias CV = ProfileIconContentView
    typealias VM = ProfileIconViewModel
}

// MARK: - properties & init

final class ProfileIconViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ProfileIconViewController {
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

extension ProfileIconViewController {}

// MARK: - private methods

private extension ProfileIconViewController {}
