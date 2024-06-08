#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugProfileUpdateViewController: VCInjectable {
        typealias CV = DebugProfileUpdateContentView
        typealias VM = DebugProfileUpdateViewModel
    }

    // MARK: - properties & init

    final class DebugProfileUpdateViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugProfileUpdateViewController {
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

    private extension DebugProfileUpdateViewController {
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
                contentView.didChangeIconImageControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeIconImageControl.send(.segment($1))
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
                contentView.didChangeSkillControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeSkillControl.send(.segment($1))
                    },
                contentView.didChangeProjectControlPublisher
                    .receive(on: DispatchQueue.main)
                    .weakSink(with: self) {
                        $0.viewModel.input.didChangeProjectControl.send(.segment($1))
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
