import Combine
import UIKit

// MARK: - inject

extension ProfileSkillUpdateViewController: VCInjectable {
    typealias CV = ProfileSkillUpdateContentView
    typealias VM = ProfileSkillUpdateViewModel
}

// MARK: - properties & init

final class ProfileSkillUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ProfileSkillUpdateViewController {
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

extension ProfileSkillUpdateViewController {}

// MARK: - private methods

private extension ProfileSkillUpdateViewController {}
