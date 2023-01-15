#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugDevelopmentViewController: VCInjectable {
        typealias CV = DebugDevelopmentContentView
        typealias VM = DebugDevelopmentViewModel
    }

    // MARK: - stored properties & init

    final class DebugDevelopmentViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugDevelopmentViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            bindToViewModel()
        }
    }

    // MARK: - private methods

    private extension DebugDevelopmentViewController {
        func bindToViewModel() {
            contentView.didSelectContentPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] row in
                    self?.viewModel.input.contentTapped.send(row)
                }
                .store(in: &cancellables)
        }
    }
#endif
