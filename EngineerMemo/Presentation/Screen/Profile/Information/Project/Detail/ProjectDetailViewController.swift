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

        editProjectBarButtonItem.customButtonPublisher?.weakSink(
            with: self,
            cancellables: &cancellables
        ) {
            $0.viewModel.input.didTapEditBarButton.send(())
        }

        deleteProjectBarButtonItem.customButtonPublisher?.weakSink(
            with: self,
            cancellables: &cancellables
        ) {
            let sheetAction: SheetAction = .init(
                title: L10n.Sheet.Action.yes,
                actionType: .alert
            ) { [weak self] in
                self?.viewModel.input.didTapDeleteBarButton.send(())
            }

            $0.showActionSheet(
                title: L10n.Sheet.Title.caution,
                message: L10n.Sheet.Message.projectDelete,
                actions: [sheetAction]
            )
        }

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
                .weakSink(with: self) {
                    $0.contentView.modelObject = $1
                },
            viewModel.output.$isDeleted
                .receive(on: DispatchQueue.main)
                .filter { $0 }
                .weakSink(with: self) {
                    $0.navigationController?.popViewController(animated: true)
                }
        ])
    }
}
