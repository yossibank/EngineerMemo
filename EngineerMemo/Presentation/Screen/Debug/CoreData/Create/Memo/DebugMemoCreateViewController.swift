#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugMemoCreateViewController: VCInjectable {
        typealias CV = DebugMemoCreateContentView
        typealias VM = DebugMemoCreateViewModel
    }

    // MARK: - properties & init

    final class DebugMemoCreateViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugMemoCreateViewController {
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

    private extension DebugMemoCreateViewController {
        func bindToViewModel() {
            contentView.titleControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.titleControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.contentControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.contentControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didTapCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.createButtonTapped.send(())
                }
                .store(in: &cancellables)
        }
    }
#endif
