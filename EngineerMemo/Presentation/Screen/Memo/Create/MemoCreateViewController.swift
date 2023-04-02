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

        viewModel.input.viewDidLoad.send(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - internal methods

extension MemoCreateViewController {}

// MARK: - private methods

private extension MemoCreateViewController {}
