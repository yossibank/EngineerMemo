import Combine

final class SampleAddViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var title = ""
        @Published var body = ""
    }

    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let addButtonTapped = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: SampleModelObject?
        @Published fileprivate(set) var appError: AppError?
        @Published fileprivate(set) var titleValidation: ValidationError?
        @Published fileprivate(set) var bodyValidation: ValidationError?
        @Published fileprivate(set) var isEnabled: Bool?
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var cancellables: Set<AnyCancellable> = .init()

    private let model: SampleModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: SampleModelInput,
        analytics: FirebaseAnalyzable
    ) {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - バリデーションエラー

        let titleValidation = binding.$title.map { [weak self] input in
            self?.validation(input: input)
        }

        let bodyValidation = binding.$body.map { [weak self] input in
            self?.validation(input: input)
        }

        let isEnabled = Publishers.CombineLatest(titleValidation, bodyValidation).map { title, body -> Bool? in
            (title?.isEnabled ?? false) && (body?.isEnabled ?? false)
        }

        // MARK: - 登録ボタンタップ

        input.addButtonTapped
            .flatMap {
                model.post(parameters: .init(
                    userId: 777,
                    title: binding.title,
                    body: binding.body
                ))
            }
            .sink { completion in
                switch completion {
                case let .failure(appError):
                    output.appError = appError

                case .finished:
                    Logger.debug(message: "サンプル作成完了")
                }
            } receiveValue: { modelObject in
                output.modelObject = modelObject
            }
            .store(in: &cancellables)

        cancellables.formUnion([
            titleValidation.assign(to: \.titleValidation, on: output),
            bodyValidation.assign(to: \.bodyValidation, on: output),
            isEnabled.assign(to: \.isEnabled, on: output)
        ])
    }
}

// MARK: - private methods

private extension SampleAddViewModel {
    func validation(input: String) -> ValidationError {
        if input.isEmpty {
            return .empty
        }

        if input.count > 20 {
            return .long
        }

        return .none
    }
}
