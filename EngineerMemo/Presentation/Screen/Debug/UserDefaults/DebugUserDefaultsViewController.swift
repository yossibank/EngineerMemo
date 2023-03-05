#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugUserDefaultsViewController: VCInjectable {
        typealias CV = DebugUserDefaultsContentView
        typealias VM = DebugUserDefaultsViewModel
    }

    // MARK: - properties & init

    final class DebugUserDefaultsViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables: Set<AnyCancellable> = .init()
    }

    // MARK: - override methods

    extension DebugUserDefaultsViewController {
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

    private extension DebugUserDefaultsViewController {
        func bindToView() {
            viewModel.output.$description
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] description in
                    self?.contentView.updateEnumView(description: description)
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.$selectedType
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] menuType in
                    self?.viewModel.input.selectedTypeChanged.send(menuType)
                }
                .store(in: &cancellables)

            contentView.selectedIndexPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.viewModel.input.segmentControlChanged.send(index)
                }
                .store(in: &cancellables)
        }
    }
#endif
