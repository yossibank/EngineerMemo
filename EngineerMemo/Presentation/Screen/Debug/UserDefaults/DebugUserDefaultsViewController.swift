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
                    self?.contentView.updateDescription(description: description)
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.$selectedKey
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] key in
                    self?.viewModel.input.didChangeUserDefaultsKey.send(key)
                }
                .store(in: &cancellables)

            contentView.didChangeSegmentIndexPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index in
                    self?.viewModel.input.didChangeSegmentIndex.send(index)
                }
                .store(in: &cancellables)

            contentView.didChangeInputTextPublisher
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] text in
                    self?.viewModel.input.didChangeInputText.send(text)
                }
                .store(in: &cancellables)

            contentView.didTapNilButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.didTapNilButton.send(())
                }
                .store(in: &cancellables)
        }
    }
#endif
