import Combine
import UIKit

// MARK: - inject

extension MemoListViewController: VCInjectable {
    typealias CV = MemoListContentView
    typealias VM = MemoListViewModel
}

// MARK: - stored properties & init

final class MemoListViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension MemoListViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.send(())

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

private extension MemoListViewController {
    func setupNavigation() {
        let addMemoBarButtonItem = UIBarButtonItem(.addMemo)

        addMemoBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            self?.viewModel.input.didTapUpdateButton.send(())
        }
        .store(in: &cancellables)

        navigationItem.rightBarButtonItem = addMemoBarButtonItem
    }

    func bindToView() {
        cancellables.formUnion([
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] modelObject in
                    self?.contentView.modelObject = modelObject
                },
            viewModel.output.$appError
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { error in
                    Logger.error(message: error.localizedDescription)
                }
        ])
    }

    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didTapUpdateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.input.didTapUpdateButton.send(())
                },
            contentView.didChangeSortPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeSort.send($0)
                },
            contentView.didChangeCategoryPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didChangeCategory.send($0)
                },
            contentView.didSelectContentPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.viewModel.input.didSelectContent.send($0)
                }
        ])
    }
}
