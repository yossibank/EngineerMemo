import Combine
import UIKit

// MARK: - inject

extension MemoCreateViewController: VCInjectable {
    typealias CV = MemoCreateContentView
    typealias VM = MemoCreateViewModel
}

// MARK: - properties & init

final class MemoCreateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension MemoCreateViewController {
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

private extension MemoCreateViewController {
    func setupNavigation() {
        let button = UIButton(type: .system)
            .addConstraint {
                $0.width.equalTo(80)
            }
            .configure {
                $0.setTitle(
                    "作成",
                    for: .normal
                )
                $0.setTitleColor(
                    .theme,
                    for: .normal
                )
                $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            }

        button.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapCreateButton.send(())

                button.apply(.memoCreateDoneButton)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    button.setTitle("作成", for: .normal)
                    button.setImage(nil, for: .normal)
                    button.imageEdgeInsets = .zero
                    button.titleEdgeInsets = .zero
                }
            }
            .store(in: &cancellables)

        navigationItem.rightBarButtonItem = .init(customView: button)
    }

    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [weak self] isFinished in
                if isFinished {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didChangeTitleTextPublisher
            .assign(to: \.binding.title, on: viewModel)
            .store(in: &cancellables)

        contentView.didChangeContentTextPublisher
            .assign(to: \.binding.content, on: viewModel)
            .store(in: &cancellables)
    }
}
