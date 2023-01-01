import Combine
import UIKit

// MARK: - inject

extension SampleDetailViewController: VCInjectable {
    typealias CV = SampleDetailContentView
    typealias VM = SampleDetailViewModel
}

// MARK: - stored properties & init

final class SampleDetailViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension SampleDetailViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension SampleDetailViewController {
    func setupNavigation() {
        let editBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.clipboard"),
            style: .plain,
            target: nil,
            action: nil
        )

        editBarButtonItem.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.barButtonTapped.send(())
            }
            .store(in: &cancellables)

        navigationItem.rightBarButtonItem = editBarButtonItem
    }
}
