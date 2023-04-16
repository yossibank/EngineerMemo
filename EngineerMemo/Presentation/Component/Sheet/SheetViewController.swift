import Combine
import UIKit

// MARK: - inject

extension SheetViewController: VCInjectable {
    typealias CV = SheetContentView
    typealias VM = NoViewModel
}

// MARK: - properties & init

final class SheetViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension SheetViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToView()
    }
}

// MARK: - private methods

private extension SheetViewController {
    func bindToView() {
        contentView.didTapDismissPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
}
