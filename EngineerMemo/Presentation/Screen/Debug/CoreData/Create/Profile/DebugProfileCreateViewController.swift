#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugProfileCreateViewController: VCInjectable {
        typealias CV = DebugProfileCreateContentView
        typealias VM = DebugProfileCreateViewModel
    }

    // MARK: - properties & init

    final class DebugProfileCreateViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugProfileCreateViewController {
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

    private extension DebugProfileCreateViewController {
        func bindToViewModel() {
            cancellables.formUnion([
                contentView.didChangeAddressControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeAddressControl.send(.segment($0))
                    },
                contentView.didChangeBirthdayControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeBirthdayControl.send(.segment($0))
                    },
                contentView.didChangeEmailControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeEmailControl.send(.segment($0))
                    },
                contentView.didChangeGenderControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeGenderControl.send(.segment($0))
                    },
                contentView.didChangeNameControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeNameControl.send(.segment($0))
                    },
                contentView.didChangePhoneNumberControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangePhoneNumberControl.send(.segment($0))
                    },
                contentView.didChangeStationControlPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        self?.viewModel.input.didChangeStationControl.send(.segment($0))
                    },
                contentView.didTapUpdateButtonPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        self?.viewModel.input.didTapUpdateButton.send(())
                    }
            ])
        }
    }
#endif
