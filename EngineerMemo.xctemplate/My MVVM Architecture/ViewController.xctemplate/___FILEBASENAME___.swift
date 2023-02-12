import Combine
import UIKit

// MARK: - inject

extension ___FILEBASENAME___: VCInjectable {
    typealias CV = NoContentView
    typealias VM = NoViewModel
}

// MARK: - stored properties & init

final class ___FILEBASENAME___: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ___FILEBASENAME___ {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - internal methods

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {}
