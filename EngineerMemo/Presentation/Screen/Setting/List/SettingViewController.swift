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
                guard let appStoreReviewURL = AppConfig.appStoreReviewURL else {
                    return
                }

                UIApplication.shared.open(appStoreReviewURL)
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

        contentView.didTapReviewCellPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapReviewCell.send(())
            }
            .store(in: &cancellables)

        contentView.didTapLicenceCellPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapLicenceCell.send(())
            }
            .store(in: &cancellables)
    }
}
