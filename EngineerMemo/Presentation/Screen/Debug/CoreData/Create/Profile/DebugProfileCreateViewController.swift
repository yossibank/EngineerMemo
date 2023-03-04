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
            contentView.addressControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.addressControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.birthdayControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.birthdayControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.emailControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.emailControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.genderControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.genderControlChanged.send(
                        DebugGenderSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.nameControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.nameControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.phoneNumberControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.phoneNumberControlChanged.send(
                        DebugPhoneNumberSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.stationControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.stationControlChanged.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didTapCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.createButtonTapped.send(())
                }
                .store(in: &cancellables)
        }
    }
#endif
