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
            .weakSink(
                with: self,
                cancellables: &cancellables
            ) {
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
            contentView.didChangeTitleInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.title, on: viewModel.binding),
            contentView.didChangeStartDateInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.startDate, on: viewModel.binding),
            contentView.didChangeEndDateInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.endDate, on: viewModel.binding),
            contentView.didChangeRoleInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.role, on: viewModel.binding),
            contentView.didChangeProcessInputPublisher
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.processes, on: viewModel.binding),
            contentView.didChangeLanguageInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.language, on: viewModel.binding),
            contentView.didChangeDatabaseInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.database, on: viewModel.binding),
            contentView.didChangeServerOSInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.serverOS, on: viewModel.binding),
            contentView.didChangeToolsInputPublisher
                .receive(on: DispatchQueue.main)
                .map { $0.components(separatedBy: "、") }
                .weakAssign(to: \.tools, on: viewModel.binding),
            contentView.didChangeContentInputPublisher
                .map { Optional($0) }
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.content, on: viewModel.binding)
        ])
    }
}
