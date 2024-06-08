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
        cancellables.formUnion([
            viewModel.output.$isEnabled
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.contentView.configureEnableButton(isEnabled: $1)
                },
            viewModel.output.$isFinished
                .debounce(for: 0.8, scheduler: DispatchQueue.main)
                .filter { $0 }
                .weakSink(with: self) {
                    $0.navigationController?.popViewController(animated: true)
                }
        ])
    }

    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didTapBarButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapBarButton.send(())
                },
            contentView.didChangeCategoryPublisher
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.binding.category, on: viewModel),
            contentView.didChangeTitleTextPublisher
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.binding.title, on: viewModel),
            contentView.didChangeContentTextPublisher
                .receive(on: DispatchQueue.main)
                .weakAssign(to: \.binding.content, on: viewModel)
        ])
    }
}
