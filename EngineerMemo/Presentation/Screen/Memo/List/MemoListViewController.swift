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
    }
}

// MARK: - internal methods

extension MemoListViewController {}

// MARK: - private methods

private extension MemoListViewController {}
