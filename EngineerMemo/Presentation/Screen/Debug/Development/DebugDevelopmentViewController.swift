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

        private var cancellables = Set<AnyCancellable>()
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
            contentView.didChangeColorThemeIndexPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeColorThemeIndex.send($0)
                }
                .store(in: &cancellables)

            contentView.didTapAPICellPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.didTapAPICell.send(())
                }
                .store(in: &cancellables)

            contentView.didTapCoreDataCellPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didTapCoreDataCell.send($0)
                }
                .store(in: &cancellables)
        }
    }
#endif
