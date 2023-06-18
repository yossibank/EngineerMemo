import Combine
import UIKit

// MARK: - inject

extension ProfileUpdateProjectViewController: VCInjectable {
    typealias CV = ProfileUpdateProjectContentView
    typealias VM = ProfileUpdateProjectViewModel
}

// MARK: - properties & init

final class ProfileUpdateProjectViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProfileUpdateProjectViewController {
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

extension ProfileUpdateProjectViewController {}

// MARK: - private methods

private extension ProfileUpdateProjectViewController {}
