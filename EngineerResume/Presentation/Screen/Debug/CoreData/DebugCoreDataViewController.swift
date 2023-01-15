import Combine
import UIKit

// MARK: - inject

extension DebugCoreDataViewController: VCInjectable {
    typealias CV = DebugCoreDataContentView
    typealias VM = DebugCoreDataViewModel
}

// MARK: - stored properties & init

final class DebugCoreDataViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugCoreDataViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - internal methods

extension DebugCoreDataViewController {}

// MARK: - private methods

private extension DebugCoreDataViewController {}
