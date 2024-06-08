import Combine
import UIKit

// MARK: - inject

extension MemoDetailViewController: VCInjectable {
    typealias CV = MemoDetailContentView
    typealias VM = MemoDetailViewModel
}

// MARK: - properties & init

final class MemoDetailViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension MemoDetailViewController {
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

private extension MemoDetailViewController {
    func setupNavigation() {
        let editMemoBarButtonItem = UIBarButtonItem(.editMemo)
        let deleteMemoBarButtonItem = UIBarButtonItem(.deleteMemo)

        editMemoBarButtonItem.customButtonPublisher?.weakSink(
            with: self,
            cancellables: &cancellables
        ) {
            $0.viewModel.input.didTapEditBarButton.send(())
        }

        deleteMemoBarButtonItem.customButtonPublisher?.weakSink(
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
                message: L10n.Sheet.Message.memoDelete,
                actions: [sheetAction]
            )
        }

        navigationItem.rightBarButtonItems = [
            editMemoBarButtonItem,
            deleteMemoBarButtonItem
        ]
    }

    func bindToView() {
        cancellables.formUnion([
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
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
