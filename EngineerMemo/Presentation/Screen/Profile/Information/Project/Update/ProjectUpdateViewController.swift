import Combine
import UIKit

// MARK: - inject

extension ProjectUpdateViewController: VCInjectable {
    typealias CV = ProjectUpdateContentView
    typealias VM = ProjectUpdateViewModel
}

// MARK: - properties & init

final class ProjectUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProjectUpdateViewController {
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

private extension ProjectUpdateViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.barButton
        )
    }

    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .filter { $0 }
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

        contentView.didChangeTitleInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.title, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeStartDateInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.startDate, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeEndDateInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.endDate, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeRoleInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.role, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeProcessInputPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.processes, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeLanguageInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.language, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeDatabaseInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.database, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeServerOSInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.serverOS, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeToolsInputPublisher
            .receive(on: DispatchQueue.main)
            .map { $0.components(separatedBy: "、") }
            .weakAssign(to: \.tools, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeContentInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.content, on: viewModel.binding)
            .store(in: &cancellables)
    }
}
