#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugProfileListViewController: VCInjectable {
        typealias CV = DebugProfileListContentView
        typealias VM = DebugProfileListViewModel
    }

    // MARK: - properties & init

    final class DebugProfileListViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugProfileListViewController {
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

    private extension DebugProfileListViewController {
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
            contentView.didDeletedModelObjectPublisher
                .sink { [weak self] modelObject in
                    self?.viewModel.input.didDeletedModelObject.send(modelObject)
                }
                .store(in: &cancellables)
        }
    }
#endif
