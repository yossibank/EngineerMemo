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
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeAddressControl.send(.segment($1))
                    },
                contentView.didChangeBirthdayControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeBirthdayControl.send(.segment($1))
                    },
                contentView.didChangeEmailControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeEmailControl.send(.segment($1))
                    },
                contentView.didChangeGenderControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeGenderControl.send(.segment($1))
                    },
                contentView.didChangeNameControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeNameControl.send(.segment($1))
                    },
                contentView.didChangePhoneNumberControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangePhoneNumberControl.send(.segment($1))
                    },
                contentView.didChangeStationControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeStationControl.send(.segment($1))
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
