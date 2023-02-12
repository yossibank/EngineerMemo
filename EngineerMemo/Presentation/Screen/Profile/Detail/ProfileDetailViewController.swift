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
        contentView.didTapEditButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelObject in
                self?.viewModel.input.editButtonTapped.send(modelObject)
            }
            .store(in: &cancellables)

        contentView.didTapSettingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.settingButtonTapped.send(())
            }
            .store(in: &cancellables)
    }
}
