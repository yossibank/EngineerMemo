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

        addMemoBarButtonItem.customButtonPublisher?.weakSink(
            with: self,
            cancellables: &cancellables
        ) {
            $0.viewModel.input.didTapUpdateButton.send(())
        }

        navigationItem.rightBarButtonItem = addMemoBarButtonItem
    }

    func bindToView() {
        cancellables.formUnion([
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.contentView.modelObject = $1
                },
            viewModel.output.$appError
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink {
                    Logger.error(message: $0.localizedDescription)
                }
        ])
    }

    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didTapUpdateButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapUpdateButton.send(())
                },
            contentView.didChangeSortPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didChangeSort.send($1)
                },
            contentView.didChangeCategoryPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didChangeCategory.send($1)
                },
            contentView.didSelectContentPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didSelectContent.send($1)
                }
        ])
    }
}
