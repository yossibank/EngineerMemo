import Combine
import UIKit

// MARK: - inject

extension ProfileUpdateViewController: VCInjectable {
    typealias CV = ProfileUpdateContentView
    typealias VM = ProfileUpdateViewModel
}

// MARK: - stored properties & init

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

        bindToViewModel()
    }
}

// MARK: - private methods

private extension ProfileUpdateViewController {
    func bindToViewModel() {
        contentView.nameInputPublisher
            .map { Optional($0) }
            .assign(to: \.name, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.birthdayInputPublisher
            .map { Optional($0) }
            .assign(to: \.birthday, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.genderInputPublisher
            .assign(to: \.gender, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.emailInputPublisher
            .map { Optional($0) }
            .assign(to: \.email, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.phoneNumberInputPublisher
            .map { Optional($0) }
            .assign(to: \.phoneNumber, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.addressInputPublisher
            .map { Optional($0) }
            .assign(to: \.address, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.stationInputPublisher
            .map { Optional($0) }
            .assign(to: \.station, on: viewModel.binding)
            .store(in: &cancellables)
    }
}
