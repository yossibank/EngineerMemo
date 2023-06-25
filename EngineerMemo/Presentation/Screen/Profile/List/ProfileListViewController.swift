import Combine
import UIKit

// MARK: - inject

extension ProfileListViewController: VCInjectable {
    typealias CV = ProfileListContentView
    typealias VM = ProfileListViewModel
}

// MARK: - properties & init

final class ProfileListViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProfileListViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.send(())

        bindToView()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.input.viewWillAppear.send(())
    }
}

// MARK: - private methods

private extension ProfileListViewController {
    func bindToView() {
        viewModel.output.$modelObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.contentView.modelObject = modelObject
            }
            .store(in: &cancellables)

        viewModel.output.$appError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { error in
                Logger.error(message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didTapIconChangeButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapIconChangeButton.send($0)
            }
            .store(in: &cancellables)

        contentView.didTapBasicSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapBasicSettingButton.send($0)
            }
            .store(in: &cancellables)

        contentView.didTapSkillSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapSkillSettingButton.send($0)
            }
            .store(in: &cancellables)

        contentView.didTapProjectSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapProjectSettingButton.send($0)
            }
            .store(in: &cancellables)

        contentView.didSelectProjectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didSelectProject.send($0)
            }
            .store(in: &cancellables)
    }
}
