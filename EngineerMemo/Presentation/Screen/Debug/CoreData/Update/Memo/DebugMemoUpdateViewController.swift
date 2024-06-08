#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugMemoUpdateViewController: VCInjectable {
        typealias CV = DebugMemoUpdateContentView
        typealias VM = DebugMemoUpdateViewModel
    }

    // MARK: - properties & init

    final class DebugMemoUpdateViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugMemoUpdateViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            bindToView()
            bindToViewModel()
        }
    }

    // MARK: - private methods

    private extension DebugMemoUpdateViewController {
        func bindToView() {
            viewModel.output.$modelObjects
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] modelObjects in
                    self?.contentView.modelObjects = modelObjects
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            cancellables.formUnion([
                contentView.didChangeCategoryControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] value in
                        self?.viewModel.input.didChangeCategoryControl.send(value)
                    },
                contentView.didChangeTitleControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] value in
                        self?.viewModel.input.didChangeTitleControl.send(.segment(value))
                    },
                contentView.didChangeContentControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] value in
                        self?.viewModel.input.didChangeContentControl.send(.segment(value))
                    },
                contentView.didChangeSearchTextPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] searchText in
                        self?.viewModel.input.didChangeSearchText.send(searchText)
                    },
                contentView.didTapUpdateButtonPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] identifier in
                        self?.viewModel.input.didTapUpdateButton.send(identifier)
                    }
            ])
        }
    }
#endif
