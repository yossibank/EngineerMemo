#if DEBUG
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

            bindToView()
        }
    }

    // MARK: - private methods

    private extension DebugProfileListViewController {
        func bindToView() {
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] modelObject in
                    self?.contentView.modelObject = modelObject
                }
                .store(in: &cancellables)
        }
    }
#endif
