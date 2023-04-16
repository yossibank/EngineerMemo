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

    private var cancellables: Set<AnyCancellable> = .init()
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
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.addBarButton
        )
    }

    func bindToView() {
        viewModel.output.$modelObjects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObjects in
                self?.contentView.modelObjects = modelObjects
            }
            .store(in: &cancellables)

        viewModel.output.$appError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { error in
                Logger.error(message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.addBarButton
            .publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapCreateButton.send(())
            }
            .store(in: &cancellables)

        contentView.didSelectContentPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.didSelectContent.send(modelObject)
            }
            .store(in: &cancellables)
    }
}
