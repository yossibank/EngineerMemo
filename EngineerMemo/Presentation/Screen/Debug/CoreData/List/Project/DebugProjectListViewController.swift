#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugProjectListViewController: VCInjectable {
        typealias CV = DebugProjectListContentView
        typealias VM = DebugProjectListViewModel
    }

    // MARK: - properties & init

    final class DebugProjectListViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugProjectListViewController {
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

    private extension DebugProjectListViewController {
        func bindToView() {
            viewModel.output.$modelObjects
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] modelObjects in
                    self?.contentView.dataSource.modelObjects = modelObjects
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.didSwipePublisher
                .sink { [weak self] modelObject in
                    self?.viewModel.input.didSwipe.send(modelObject)
                }
                .store(in: &cancellables)
        }
    }
#endif
