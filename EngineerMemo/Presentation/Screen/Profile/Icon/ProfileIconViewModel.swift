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
    private var cancellables: Set<AnyCancellable> = .init()

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

        // MARK: - viewWillAppear

        input.viewWillAppear
            .sink { _ in
                analytics.sendEvent(.screenView)
            }
            .store(in: &cancellables)

        // MARK: - アイコン変更(CoreData)

        input.didChangeIconData
            .sink { [weak self] iconImage in
                guard let self else {
                    return
                }

                self.modelObject.iconImage = iconImage
                self.model.iconImageUpdate(modelObject: self.modelObject)
            }
            .store(in: &cancellables)

        // MARK: - アイコン変更(UserDefaults)

        input.didChangeIconIndex
            .sink { index in
                model.iconImageUpdate(index: index)
            }
            .store(in: &cancellables)
    }
}
