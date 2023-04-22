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

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugAPIViewController {
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

    private extension DebugAPIViewController {
        func bindToView() {
            viewModel.output.$apiInfo
                .receive(on: DispatchQueue.main)
                .assign(to: \.apiInfo, on: contentView)
                .store(in: &cancellables)

            viewModel.output.$apiResult
                .receive(on: DispatchQueue.main)
                .assign(to: \.apiResult, on: contentView)
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.$menuType
                .receive(on: DispatchQueue.main)
                .assign(to: \.menuType, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didChangePathTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.path, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didChangeUserIdTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.userId, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didChangeIdTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.id, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didChangeTitleTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.title, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didChangeBodyTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.body, on: viewModel.binding)
                .store(in: &cancellables)

            contentView.didTapSendButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] menuType in
                    self?.viewModel.input.didTapSendButton.send(menuType)
                }
                .store(in: &cancellables)
        }
    }
#endif
