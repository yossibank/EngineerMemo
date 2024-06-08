import Combine
import UIKit

// MARK: - inject

extension ProjectDetailViewController: VCInjectable {
    typealias CV = ProjectDetailContentView
    typealias VM = ProjectDetailViewModel
}

// MARK: - properties & init

final class ProjectDetailViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProjectDetailViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.send(())

        setupNavigation()
        bindToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension ProjectDetailViewController {
    func setupNavigation() {
        let editProjectBarButtonItem = UIBarButtonItem(.editProject)
        let deleteProjectBarButtonItem = UIBarButtonItem(.deleteProject)

        editProjectBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            self?.viewModel.input.didTapEditBarButton.send(())
        }
        .store(in: &cancellables)

        deleteProjectBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            let sheetAction: SheetAction = .init(
                title: L10n.Sheet.Action.yes,
                actionType: .alert
            ) { [weak self] in
                self?.viewModel.input.didTapDeleteBarButton.send(())
            }

            self?.showActionSheet(
                title: L10n.Sheet.Title.caution,
                message: L10n.Sheet.Message.projectDelete,
                actions: [sheetAction]
            )
        }
        .store(in: &cancellables)

        navigationItem.rightBarButtonItems = [
            editProjectBarButtonItem,
            deleteProjectBarButtonItem
        ]
    }

    func bindToView() {
        cancellables.formUnion([
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] in
                    self?.contentView.modelObject = $0
                },
            viewModel.output.$isDeleted
                .receive(on: DispatchQueue.main)
                .filter { $0 }
                .sink { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
        ])
    }
}
