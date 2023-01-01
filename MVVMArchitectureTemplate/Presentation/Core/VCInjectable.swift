import UIKit

protocol VCInjectable: UIViewController {
    associatedtype CV: ContentView
    associatedtype VM: ViewModel

    var contentView: CV! { get set }
    var viewModel: VM! { get set }

    func inject(
        contentView: CV,
        viewModel: VM
    )
}

extension VCInjectable {
    func inject(
        contentView: CV,
        viewModel: VM
    ) {
        self.contentView = contentView
        self.viewModel = viewModel
    }
}

extension VCInjectable where CV == NoContentView {
    func inject(viewModel: VM) {
        contentView = CV()
        self.viewModel = viewModel
    }
}

extension VCInjectable where VM == NoViewModel {
    func inject(contentView: CV) {
        self.contentView = contentView
        viewModel = VM()
    }
}

extension VCInjectable where CV == NoContentView, VM == NoViewModel {
    func inject() {
        contentView = CV()
        viewModel = VM()
    }
}
