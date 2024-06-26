import Combine
import UIKit

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
            .filter { $0 }
            .weakSink(with: self, cancellables: &cancellables) {
                $0.navigationController?.popViewController(animated: true)
            }
    }

    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didTapBarButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapBarButton.send(())
                },
            contentView.didChangeNameInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.name, on: viewModel.binding),
            contentView.didChangeBirthdayInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.birthday, on: viewModel.binding),
            contentView.didChangeGenderInputPublisher
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.gender, on: viewModel.binding),
            contentView.didChangeEmailInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.email, on: viewModel.binding),
            contentView.didChangePhoneNumberInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.phoneNumber, on: viewModel.binding),
            contentView.didChangeAddressInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.address, on: viewModel.binding),
            contentView.didChangeStationInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.station, on: viewModel.binding)
        ])
    }
}
