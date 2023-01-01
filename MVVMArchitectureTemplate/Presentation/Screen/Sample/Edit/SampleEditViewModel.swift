import Combine

final class SampleEditViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title = ""
        @Published var body = ""
    }

    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let editButtonTapped = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: SampleModelObject?
        @Published fileprivate(set) var appError: AppError?
        @Published fileprivate(set) var isEnabled: Bool?
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var cancellables: Set<AnyCancellable> = .init()

    private let model: SampleModelInput
    private let modelObject: SampleModelObject
    private let analytics: FirebaseAnalyzable

    init(
        model: SampleModelInput,
        modelObject: SampleModelObject,
        analytics: FirebaseAnalyzable
    ) {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
        self.input = input
        self.output = output
        self.model = model
        self.modelObject = modelObject
        self.analytics = analytics

        binding.title = modelObject.title
        binding.body = modelObject.body

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 編集ボタン有効化

        let isEnabled = Publishers.CombineLatest(binding.$title, binding.$body).map { title, body -> Bool? in
            !title.isEmpty && !body.isEmpty
        }

        // MARK: - 編集ボタンタップ

        input.editButtonTapped
            .flatMap {
                model.put(
                    userId: modelObject.userId,
                    parameters: .init(
                        userId: modelObject.userId,
                        id: modelObject.id,
                        title: binding.title,
                        body: binding.body
                    )
                )
            }
            .sink { completion in
                switch completion {
                case let .failure(appError):
                    output.appError = appError

                case .finished:
                    Logger.debug(message: "サンプル編集完了")
                }
            } receiveValue: { modelObject in
                output.modelObject = modelObject
            }
            .store(in: &cancellables)

        cancellables.formUnion([
            isEnabled.assign(to: \.isEnabled, on: output)
        ])
    }
}
