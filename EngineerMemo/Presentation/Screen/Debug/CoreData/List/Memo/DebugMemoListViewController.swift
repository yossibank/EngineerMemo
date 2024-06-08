#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugMemoListViewController: VCInjectable {
        typealias CV = DebugMemoListContentView
        typealias VM = DebugMemoListViewModel
    }

    // MARK: - properties & init

    final class DebugMemoListViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugMemoListViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            viewModel.input.viewDidLoad.send(())

            bindToView()
            bindToViewModel()
        }
    }

    // MARK: - private methods

    private extension DebugMemoListViewController {
        func bindToView() {
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .weakSink(with: self, cancellables: &cancellables) {
                    $0.contentView.dataSource.modelObject = $1
                }
        }

        func bindToViewModel() {
            contentView.didSwipePublisher
                .weakSink(with: self, cancellables: &cancellables) {
                    $0.viewModel.input.didSwipe.send($1)
                }
        }
    }
#endif
