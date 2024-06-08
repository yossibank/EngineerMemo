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
        cancellables.formUnion([
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.contentView.modelObject = $1
                },
            viewModel.output.$appError
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink {
                    Logger.error(message: $0.localizedDescription)
                }
        ])
    }

    func bindToViewModel() {
        cancellables.formUnion([
            contentView.didTapIconChangeButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapIconChangeButton.send($1)
                },
            contentView.didTapBasicSettingButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapBasicSettingButton.send($1)
                },
            contentView.didTapSkillSettingButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapSkillSettingButton.send($1)
                },
            contentView.didChangeProjectSortTypePublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didChangeProjectSortType.send($1)
                },
            contentView.didTapProjectCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didTapProjectCreateButton.send($1)
                },
            contentView.didSelectProjectCellPublisher
                .receive(on: DispatchQueue.main)
                .weakSink(with: self) {
                    $0.viewModel.input.didSelectProjectCell.send($1)
                }
        ])
    }
}
