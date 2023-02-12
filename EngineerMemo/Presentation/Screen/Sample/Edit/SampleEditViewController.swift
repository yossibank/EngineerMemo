import Combine
import UIKit

// MARK: - inject

extension SampleEditViewController: VCInjectable {
    typealias CV = SampleEditContentView
    typealias VM = SampleEditViewModel
}

// MARK: - properties & init

final class SampleEditViewController: UIViewController {
    var viewModel: VM!
    var contentView: CV!

    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - override methods

extension SampleEditViewController {
    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
        bindToView()
    }
}

// MARK: - private methods

private extension SampleEditViewController {
    func bindToViewModel() {
        contentView.didChangeTitleTextPublisher
            .assign(to: \.title, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didChangeBodyTextPublisher
            .assign(to: \.body, on: viewModel.binding)
            .store(in: &cancellables)

        contentView.didTapEditButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.editButtonTapped.send(())
            }
            .store(in: &cancellables)
    }

    func bindToView() {
        viewModel.output.$modelObject
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { modelObject in
                Logger.debug(message: "\(modelObject)")
            }
            .store(in: &cancellables)

        viewModel.output.$appError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { appError in
                Logger.error(message: "\(appError)")
            }
            .store(in: &cancellables)

        viewModel.output.$isEnabled
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isEnabled in
                self?.contentView.buttonEnabled(isEnabled)
            }
            .store(in: &cancellables)
    }
}
