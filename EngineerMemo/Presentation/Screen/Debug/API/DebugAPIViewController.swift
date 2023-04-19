#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugAPIViewController: VCInjectable {
        typealias CV = DebugAPIContentView
        typealias VM = DebugAPIViewModel
    }

    // MARK: - properties & init

    final class DebugAPIViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugAPIViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }
    }

    // MARK: - internal methods

    extension DebugAPIViewController {}

    // MARK: - private methods

    private extension DebugAPIViewController {}
#endif
