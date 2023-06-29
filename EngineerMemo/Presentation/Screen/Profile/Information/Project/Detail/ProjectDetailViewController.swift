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

        bindToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension ProjectDetailViewController {
    func bindToView() {
        viewModel.output.$modelObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.contentView.modelObject = $0
            }
            .store(in: &cancellables)
    }
}
