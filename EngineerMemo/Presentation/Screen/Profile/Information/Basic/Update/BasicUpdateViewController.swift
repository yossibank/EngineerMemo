import Combine
import UIKit
import UIKitHelper

// MARK: - inject

extension BasicUpdateViewController: VCInjectable {
    typealias CV = BasicUpdateContentView
    typealias VM = BasicUpdateViewModel
}

// MARK: - properties & init

final class BasicUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension BasicUpdateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        bindToView()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension BasicUpdateViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.barButton
        )
    }

    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didTapBarButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapBarButton.send(())
            }
            .store(in: &cancellables)

        contentView.didChangeNameInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.name, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeBirthdayInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.birthday, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeGenderInputPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.gender, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeEmailInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.email, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangePhoneNumberInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.phoneNumber, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeAddressInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.address, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeStationInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.station, on: viewModel.binding)
            .store(in: &cancellables)
    }
}
