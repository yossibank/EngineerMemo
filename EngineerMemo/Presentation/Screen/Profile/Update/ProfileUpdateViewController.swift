import Combine
import UIKit

// MARK: - inject

extension ProfileUpdateViewController: VCInjectable {
    typealias CV = ProfileUpdateContentView
    typealias VM = ProfileUpdateViewModel
}

// MARK: - stored properties & init

final class ProfileUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ProfileUpdateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - internal methods

extension ProfileUpdateViewController {}

// MARK: - private methods

private extension ProfileUpdateViewController {}
