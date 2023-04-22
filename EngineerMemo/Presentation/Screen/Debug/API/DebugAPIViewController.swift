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
            viewModel.output.$api
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] api in
                    self?.contentView.api = api
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.didChangePathTextFieldPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.path, on: viewModel.binding)
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
