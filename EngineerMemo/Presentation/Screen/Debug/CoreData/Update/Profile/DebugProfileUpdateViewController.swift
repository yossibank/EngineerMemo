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
                .sink { [weak self] in
                    self?.contentView.modelObjects = $0
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.didChangeAddressControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeAddressControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeBirthdayControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeBirthdayControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeEmailControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeEmailControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeGenderControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeGenderControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeIconImageControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeIconImageControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeNameControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.input.didChangeNameControl.send(.segment(value))
                }
                .store(in: &cancellables)

            contentView.didChangePhoneNumberControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangePhoneNumberControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeStationControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeStationControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeSkillControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeSkillControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeProjectControlPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeProjectControl.send(.segment($0))
                }
                .store(in: &cancellables)

            contentView.didChangeSearchTextPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeSearchText.send($0)
                }
                .store(in: &cancellables)

            contentView.didTapUpdateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didTapUpdateButton.send($0)
                }
                .store(in: &cancellables)
        }
    }
#endif
