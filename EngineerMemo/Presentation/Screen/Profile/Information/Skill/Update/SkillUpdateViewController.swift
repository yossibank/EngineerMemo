import Combine
import UIKit

// MARK: - inject

extension SkillUpdateViewController: VCInjectable {
    typealias CV = SkillUpdateContentView
    typealias VM = SkillUpdateViewModel
}

// MARK: - properties & init

final class SkillUpdateViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables = Set<AnyCancellable>()
}

// MARK: - override methods

extension SkillUpdateViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

private extension SkillUpdateViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.barButton
        )
    }

    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    func bindToViewModel() {
        contentView.didTapBarButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.didTapBarButton.send(())
            }
            .store(in: &cancellables)

        contentView.didChangeCareerInputPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.engineerCareer, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeLanguageCareerInputPublisher
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.languageCareer, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeLanguageInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.language, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeToeicScoreInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.toeic, on: viewModel.binding)
            .store(in: &cancellables)
    }
}
