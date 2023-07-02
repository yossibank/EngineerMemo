import Combine
import UIKit

// MARK: - inject

extension LicenceViewController: VCInjectable {
    typealias CV = LicenceContentView
    typealias VM = LicenceViewModel
}

// MARK: - properties & init

final class LicenceViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension LicenceViewController {
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
