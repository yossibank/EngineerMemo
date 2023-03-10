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

        private var cancellables: Set<AnyCancellable> = .init()
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
            contentView.didChangeAddressControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeAddressControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeBirthdayControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeBirthdayControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeEmailControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeEmailControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeGenderControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeGenderControl.send(
                        DebugGenderSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeNameControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeNameControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangePhoneNumberControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangePhoneNumberControl.send(
                        DebugPhoneNumberSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeStationControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeStationControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didTapCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.didTapCreateButton.send(())
                }
                .store(in: &cancellables)
        }
    }
#endif
