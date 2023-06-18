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

    private var cancellables = Set<AnyCancellable>()
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

private extension ProfileUpdateSkillViewController {
    func setupNavigation() {
        navigationItem.rightBarButtonItem = .init(
            customView: contentView.barButton
        )
    }

    func bindToView() {
        viewModel.output.$isFinished
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .sink { [weak self] isFinished in
                if isFinished {
                    self?.navigationController?.popViewController(animated: true)
                }
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
            .assign(to: \.engineerCareer, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeLanguageCareerInputPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.languageCareer, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeLanguageInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.language, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeToeicScoreInputPublisher
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.toeic, on: viewModel.binding)
            .store(in: &cancellables)
    }
}
