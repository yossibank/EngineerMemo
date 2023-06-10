import Combine
import UIKit

// MARK: - inject

extension ProfileUpdateSkillViewController: VCInjectable {
    typealias CV = ProfileUpdateSkillContentView
    typealias VM = ProfileUpdateSkillViewModel
}

// MARK: - properties & init

final class ProfileUpdateSkillViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension ProfileUpdateSkillViewController {
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

extension ProfileUpdateSkillViewController {}

// MARK: - private methods

private extension ProfileUpdateSkillViewController {}
