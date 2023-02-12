import Combine
import UIKit

// MARK: - inject

extension SampleListViewController: VCInjectable {
    typealias CV = SampleListContentView
    typealias VM = SampleListViewModel
}

// MARK: - properties & init

final class SampleListViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension SampleListViewController {
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

private extension SampleListViewController {
    func setupNavigation() {
        let addBarButtonItem = UIBarButtonItem(
            image: .add,
            style: .plain,
            target: nil,
            action: nil
        )

        addBarButtonItem.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.barButtonTapped.send(())
            }
            .store(in: &cancellables)

        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    func bindToView() {
        viewModel.output.$modelObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                guard let self else {
                    return
                }

                self.contentView.modelObject = modelObject
            }
            .store(in: &cancellables)

        viewModel.output.$appError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { error in
                Logger.error(message: error.localizedDescription)
            }
            .store(in: &cancellables)

        viewModel.output.$isLoading
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isLoading in
                guard let self else {
                    return
                }

                self.contentView.configureIndicator(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didSelectContentPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.viewModel.input.contentTapped.send(indexPath)
            }
            .store(in: &cancellables)
    }
}
