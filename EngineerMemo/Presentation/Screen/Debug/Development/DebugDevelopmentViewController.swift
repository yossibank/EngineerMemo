#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugDevelopmentViewController: VCInjectable {
        typealias CV = DebugDevelopmentContentView
        typealias VM = DebugDevelopmentViewModel
    }

    // MARK: - properties & init

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
            contentView.didTapCoreDataCellPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] action in
                    self?.viewModel.input.didTapCoreDataCell.send(action)
                }
                .store(in: &cancellables)

            contentView.didTapUserDefaultsCellPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.didTapUserDefaultsCell.send(())
                }
                .store(in: &cancellables)
        }
    }
#endif
