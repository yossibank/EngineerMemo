import Combine
import UIKit

// MARK: - inject

extension DebugUserDefaultsViewController: VCInjectable {
    typealias CV = DebugUserDefaultsContentView
    typealias VM = DebugUserDefaultsViewModel
}

// MARK: - properties & init

final class DebugUserDefaultsViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugUserDefaultsViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - private methods

private extension DebugUserDefaultsViewController {}
