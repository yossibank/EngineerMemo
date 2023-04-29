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

        private var cancellables: Set<AnyCancellable> = .init()
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
                .sink { [weak self] modelObjects in
                    self?.contentView.modelObjects = modelObjects
                }
                .store(in: &cancellables)
        }

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

            contentView.didChangeIconImageControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeIconImageControl.send(
                        DebugIconImageSegment.segment(value)
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

            contentView.didChangeSkillControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeSkillControl.send(
                        DebugCoreDataSegment.segment(value)
                    )
                }
                .store(in: &cancellables)

            contentView.didChangeSearchTextPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] searchText in
                    self?.viewModel.input.didChangeSearchText.send(searchText)
                }
                .store(in: &cancellables)

            contentView.didTapUpdateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] identifier in
                    self?.viewModel.input.didTapUpdateButton.send(identifier)
                }
                .store(in: &cancellables)
        }
    }
#endif
