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

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugAPIViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            setupNavigation()
            bindToView()
            bindToViewModel()
        }
    }

    // MARK: - private methods

    private extension DebugAPIViewController {
        func setupNavigation() {
            navigationItem.rightBarButtonItem = .init(
                customView: contentView.barButton
            )
        }

        func bindToView() {
            cancellables.formUnion([
                viewModel.output.$isLoading
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.isLoading, on: contentView),
                viewModel.output.$apiInfo
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.apiInfo, on: contentView),
                viewModel.output.$apiResult
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.apiResult, on: contentView)
            ])
        }

        func bindToViewModel() {
            cancellables.formUnion([
                contentView.$menuType
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.menuType, on: viewModel.binding),
                contentView.didChangePathTextFieldPublisher
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.path, on: viewModel.binding),
                contentView.didChangeUserIdTextFieldPublisher
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.userId, on: viewModel.binding),
                contentView.didChangeIdTextFieldPublisher
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.id, on: viewModel.binding),
                contentView.didChangeTitleTextFieldPublisher
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.title, on: viewModel.binding),
                contentView.didChangeBodyTextFieldPublisher
                    .receive(on: DispatchQueue.main)
                    .weakAssign(to: \.body, on: viewModel.binding),
                contentView.didTapSendButtonPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] menuType in
                        self?.viewModel.input.didTapSendButton.send(menuType)
                    }
            ])
        }
    }
#endif
