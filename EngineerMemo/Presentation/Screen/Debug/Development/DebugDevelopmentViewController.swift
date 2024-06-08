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
            cancellables.formUnion([
                contentView.didChangeColorThemeIndexPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeColorThemeIndex.send($1)
                    },
                contentView.didTapAPICellPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didTapAPICell.send(())
                    },
                contentView.didTapCoreDataCellPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didTapCoreDataCell.send($1)
                    }
            ])
        }
    }
#endif
