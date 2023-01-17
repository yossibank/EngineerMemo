import Combine
import UIKit

// MARK: - inject

extension DebugProfileCreateViewController: VCInjectable {
    typealias CV = DebugProfileCreateContentView
    typealias VM = DebugProfileCreateViewModel
}

// MARK: - stored properties & init

final class DebugProfileCreateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugProfileCreateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - private methods

private extension DebugProfileCreateViewController {}
