#if DEBUG
    import Combine
    import UIKit

    // MARK: - display type

    enum DebugCoreDataDisplayType {
        case list
        case create
        case update
    }

    // MARK: - inject

    extension DebugCoreDataMenuViewController: VCInjectable {
        typealias CV = DebugCoreDataMenuContentView
        typealias VM = NoViewModel
    }

    // MARK: - properties & init

    final class DebugCoreDataMenuViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()

        private let displayType: DebugCoreDataDisplayType

        init(displayType: DebugCoreDataDisplayType) {
            self.displayType = displayType

            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - override methods

    extension DebugCoreDataMenuViewController {
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

    private extension DebugCoreDataMenuViewController {
        func bindToView() {
            contentView.$selectedMenuType
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }

                    contentView.viewUpdate(
                        vc: self,
                        displayType: displayType
                    )
                }
                .store(in: &cancellables)
        }
    }
#endif
