import Combine
import Foundation

final class ProfileIconViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didChangeIconData = PassthroughSubject<Data?, Never>()
        let didChangeIconIndex = PassthroughSubject<Int, Never>()
    }

    final class Output: OutputObject {}

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var modelObject: ProfileModelObject
    private var cancellables = Set<AnyCancellable>()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        modelObject: ProfileModelObject,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.modelObject = modelObject
        self.analytics = analytics

        cancellables.formUnion([
            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - アイコン変更(CoreData)

            input.didChangeIconData.weakSink(with: self) {
                $0.modelObject.iconImage = $1
                $0.updateIconImage()
            },

            // MARK: - アイコン変更(UserDefaults)

            input.didChangeIconIndex.sink {
                model.updateProfileIcon(index: $0)
            }
        ])
    }
}

// MARK: - private methods

private extension ProfileIconViewModel {
    func updateIconImage() {
        model.updateIconImage(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
