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

        editMemoBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            self?.viewModel.input.didTapEditBarButton.send(())
        }
        .store(in: &cancellables)

        deleteMemoBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            let sheetAction: SheetAction = .init(
                title: L10n.Sheet.yes,
                actionType: .alert
            ) { [weak self] in
                self?.viewModel.input.didTapDeleteBarButton.send(())
            }

            self?.showActionSheet(
                title: L10n.Sheet.caution,
                message: L10n.Sheet.memoDelete,
                actions: [sheetAction]
            )
        }
        .store(in: &cancellables)

        navigationItem.rightBarButtonItems = [
            editMemoBarButtonItem,
            deleteMemoBarButtonItem
        ]
    }

    func bindToView() {
        viewModel.output.$modelObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.contentView.modelObject = $0
            }
            .store(in: &cancellables)

        viewModel.output.$isDeleted
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}
