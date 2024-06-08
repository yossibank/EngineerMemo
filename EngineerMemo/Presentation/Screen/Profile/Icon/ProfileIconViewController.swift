import Combine
import UIKit

// MARK: - inject

extension ProfileIconViewController: VCInjectable {
    typealias CV = ProfileIconContentView
    typealias VM = ProfileIconViewModel
}

// MARK: - properties & init

final class ProfileIconViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProfileIconViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension ProfileIconViewController {
    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didChangeIconDataPublisher
                .sink { [weak self] in
                    self?.viewModel.input.didChangeIconData.send($0)
                },
            contentView.didChangeIconIndexPublisher
                .sink { [weak self] in
                    self?.viewModel.input.didChangeIconIndex.send($0)
                }
        ])
    }
}
