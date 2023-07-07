import Combine
import UIKit

// MARK: - inject

extension SettingViewController: VCInjectable {
    typealias CV = SettingContentView
    typealias VM = SettingViewModel
}

// MARK: - properties & init

final class SettingViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension SettingViewController {
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

private extension SettingViewController {
    func bindToView() {
        viewModel.output.$didTapReview
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                AppConfig.openAppReview()
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didChangeColorThemeIndexPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didChangeColorThemeIndex.send($0)
            }
            .store(in: &cancellables)

        contentView.didTapApplicationCellPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.input.didTapApplicationCell.send($0)
            }
            .store(in: &cancellables)
    }
}
