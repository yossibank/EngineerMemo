import Combine
import UIKit

// MARK: - inject

extension ProjectDetailViewController: VCInjectable {
    typealias CV = ProjectDetailContentView
    typealias VM = ProjectDetailViewModel
}

// MARK: - properties & init

final class ProjectDetailViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProjectDetailViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.send(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - internal methods

extension ProjectDetailViewController {}

// MARK: - private methods

private extension ProjectDetailViewController {}
