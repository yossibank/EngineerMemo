import Combine
import UIKit

// MARK: - inject

extension ProfileUpdateViewController: VCInjectable {
    typealias CV = ProfileUpdateContentView
    typealias VM = ProfileUpdateViewModel
}

// MARK: - properties & init

final class ProfileUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ProfileUpdateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.send(())

        bindToView()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension ProfileUpdateViewController {
    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isFinished in
                if isFinished {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didChangeNameInputPublisher
            .map { Optional($0) }
            .assign(to: \.name, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeBirthdayInputPublisher
            .map { Optional($0) }
            .assign(to: \.birthday, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeGenderInputPublisher
            .assign(to: \.gender, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeEmailInputPublisher
            .map { Optional($0) }
            .assign(to: \.email, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangePhoneNumberInputPublisher
            .map { Optional($0) }
            .assign(to: \.phoneNumber, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeAddressInputPublisher
            .map { Optional($0) }
            .assign(to: \.address, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeStationInputPublisher
            .map { Optional($0) }
            .assign(to: \.station, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didTapSaveButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapSaveButton.send(())
            }
            .store(in: &cancellables)
    }
}
