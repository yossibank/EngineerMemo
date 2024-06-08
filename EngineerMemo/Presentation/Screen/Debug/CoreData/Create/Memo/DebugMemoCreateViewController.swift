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

        private var cancellables = Set<AnyCancellable>()
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
            cancellables.formUnion([
                contentView.didChangeCategoryControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeCategoryControl.send($1)
                    },
                contentView.didChangeTitleControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeTitleControl.send(.segment($1))
                    },
                contentView.didChangeContentControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeContentControl.send(.segment($1))
                    },
                contentView.didTapUpdateButtonPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didTapUpdateButton.send(())
                    }
            ])
        }
    }
#endif
