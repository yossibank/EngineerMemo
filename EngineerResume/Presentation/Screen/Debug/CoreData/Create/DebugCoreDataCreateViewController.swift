import Combine
import UIKit

// MARK: - inject

extension DebugCoreDataCreateViewController: VCInjectable {
    typealias CV = DebugCoreDataCreateContentView
    typealias VM = DebugCoreDataCreateViewModel
}

// MARK: - stored properties & init

final class DebugCoreDataCreateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension DebugCoreDataCreateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToView()
    }
}

// MARK: - internal methods

extension DebugCoreDataCreateViewController {}

// MARK: - private methods

private extension DebugCoreDataCreateViewController {
    func bindToView() {
        contentView.$selectedType
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.contentView.viewUpdate(vc: self)
            }
            .store(in: &cancellables)
    }
}
