#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugCoreDataListViewController: VCInjectable {
        typealias CV = DebugCoreDataListContentView
        typealias VM = NoViewModel
    }

    // MARK: - stored properties & init

    final class DebugCoreDataListViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugCoreDataListViewController {
        override func loadView() {
            super.loadView()

            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            bindToView()
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataListViewController {
        func bindToView() {
            contentView.$selectedType
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }

                    self.contentView.viewUpdate(vc: self)
                }
                .store(in: &cancellables)
        }
    }
#endif
