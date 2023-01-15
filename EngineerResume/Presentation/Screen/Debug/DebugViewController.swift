import Combine
import UIKit

// MARK: - inject

extension DebugViewController: VCInjectable {
    typealias CV = DebugContentView
    typealias VM = DebugViewModel
}

// MARK: - stored properties & init

final class DebugViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - internal methods

extension DebugViewController {}

// MARK: - private methods

private extension DebugViewController {}
