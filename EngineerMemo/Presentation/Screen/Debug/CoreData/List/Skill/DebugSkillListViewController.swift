#if DEBUG
    import Combine
    import UIKit

    // MARK: - inject

    extension DebugSkillListViewController: VCInjectable {
        typealias CV = DebugSkillListContentView
        typealias VM = DebugSkillListViewModel
    }

    // MARK: - properties & init

    final class DebugSkillListViewController: UIViewController {
        var viewModel: VM!
        var contentView: CV!

        private var cancellables = Set<AnyCancellable>()
    }

    // MARK: - override methods

    extension DebugSkillListViewController {
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
    }

    // MARK: - private methods

    private extension DebugSkillListViewController {
        func bindToView() {
            viewModel.output.$modelObject
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] modelObject in
                    self?.contentView.dataSource.modelObject = modelObject
                }
                .store(in: &cancellables)
        }

        func bindToViewModel() {
            contentView.didDeletedModelObjectPublisher
                .sink { [weak self] modelObject in
                    self?.viewModel.input.didDeletedModelObject.send(modelObject)
                }
                .store(in: &cancellables)
        }
    }
#endif
