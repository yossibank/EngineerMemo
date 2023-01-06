import Combine
import Foundation

final class SampleListViewModel: ViewModel {
    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let barButtonTapped = PassthroughSubject<Void, Never>()
        let contentTapped = PassthroughSubject<IndexPath, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: [SampleModelObject] = []
        @Published fileprivate(set) var isLoading: Bool?
        @Published fileprivate(set) var error: AppError?
    }

    let input: Input
    let output: Output
    let binding = NoBinding()

    private var cancellables: Set<AnyCancellable> = .init()

    private let core: ProfileModel = .init()
    private let model: SampleModelInput
    private let routing: SampleListRoutingInput
    private let analytics: FirebaseAnalyzable

    init(
        model: SampleModelInput,
        routing: SampleListRoutingInput,
        analytics: FirebaseAnalyzable
    ) {
        let input = Input()
        let output = Output()

        self.input = input
        self.output = output
        self.model = model
        self.routing = routing
        self.analytics = analytics

        core.fetch { result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)

            case let .success(values):
                print(values)
            }
        }

        // MARK: - 詳細API取得

        output.isLoading = true

        model.get(userId: nil).sink { completion in
            output.isLoading = false

            switch completion {
            case let .failure(error):
                output.error = error

            case .finished:
                Logger.debug(message: "詳細API読み込み完了")
            }
        } receiveValue: { modelObject in
            output.modelObject = modelObject
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - ナビゲーションボタンタップ

        input.barButtonTapped.sink { _ in
            routing.showAddScreen()
        }
        .store(in: &cancellables)

        // MARK: - セルタップ

        input.contentTapped.sink { indexPath in
            let modelObject = output.modelObject[indexPath.row]
            analytics.sendEvent(.tapSmapleList(userId: modelObject.userId))
            routing.showDetailScreen(modelObject)
        }
        .store(in: &cancellables)
    }
}
