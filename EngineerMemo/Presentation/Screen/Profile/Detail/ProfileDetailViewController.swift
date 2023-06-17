import Combine
import UIKit

// MARK: - inject

extension ProfileDetailViewController: VCInjectable {
    typealias CV = ProfileDetailContentView
    typealias VM = ProfileDetailViewModel
}

// MARK: - properties & init

final class ProfileDetailViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension ProfileDetailViewController {
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

private extension ProfileDetailViewController {
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
            .sink { [weak self] modelObject in
                self?.viewModel.input.didTapIconChangeButton.send(modelObject)
            }
            .store(in: &cancellables)

        contentView.didTapBasicEditButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.didTapBasicEditButton.send(modelObject)
            }
            .store(in: &cancellables)

        contentView.didTapBasicSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.didTapBasicSettingButton.send(modelObject)
            }
            .store(in: &cancellables)

        contentView.didTapSkillEditButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.didTapSkillEditButton.send(modelObject)
            }
            .store(in: &cancellables)

        contentView.didTapSkillSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.didTapSkillSettingButton.send(modelObject)
            }
            .store(in: &cancellables)
    }
}
