import Combine
import UIKit

// MARK: - inject

extension DebugProfileListViewController: VCInjectable {
    typealias CV = DebugProfileListContentView
    typealias VM = DebugProfileListViewModel
}

// MARK: - stored properties & init

final class DebugProfileListViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugProfileListViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - internal methods

extension DebugProfileListViewController {}

// MARK: - private methods

private extension DebugProfileListViewController {}
