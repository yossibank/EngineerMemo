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
                .weakSink(with: self, cancellables: &cancellables) {
                    $0.contentView.modelObjects = $1
                }
        }

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
                contentView.didChangeSearchTextPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeSearchText.send($1)
                    },
                contentView.didTapUpdateButtonPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didTapUpdateButton.send($1)
                    }
            ])
        }
    }
#endif
