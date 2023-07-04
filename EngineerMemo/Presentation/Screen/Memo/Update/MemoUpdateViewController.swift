import Combine
import UIKit

// MARK: - inject

extension MemoUpdateViewController: VCInjectable {
    typealias CV = MemoUpdateContentView
    typealias VM = MemoUpdateViewModel
}

// MARK: - properties & init

final class MemoUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension MemoUpdateViewController {
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

private extension MemoUpdateViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.barButton
        )
    }

    func bindToView() {
        viewModel.output.$isEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.contentView.configureEnableButton(isEnabled: $0)
            }
            .store(in: &cancellables)

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

        contentView.didChangeCategoryPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.binding.category, on: viewModel)
            .store(in: &cancellables)

        contentView.didChangeTitleTextPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.binding.title, on: viewModel)
            .store(in: &cancellables)

        contentView.didChangeContentTextPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.binding.content, on: viewModel)
            .store(in: &cancellables)
    }
}
