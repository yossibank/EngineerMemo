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

    private var cancellables: Set<AnyCancellable> = .init()
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

        setupNavigation()
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
    func setupNavigation() {
        let reloadBarButtonItem = UIBarButtonItem(.reload)

        reloadBarButtonItem.customButtonPublisher?.sink { [weak self] _ in
            if self?.contentView.modelObject == nil {
                self?.viewModel.input.viewDidLoad.send(())
            }
        }
        .store(in: &cancellables)

        navigationItem.leftBarButtonItem = reloadBarButtonItem
    }

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
            .sink { [weak self] _ in
                self?.viewModel.input.didTapBasicSettingButton.send(())
            }
            .store(in: &cancellables)

        contentView.didTapSkillSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapSkillSettingButton.send(())
            }
            .store(in: &cancellables)
    }
}
