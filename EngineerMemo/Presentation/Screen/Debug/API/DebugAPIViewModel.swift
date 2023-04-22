#if DEBUG
    import Combine
    import Foundation

    final class DebugAPIViewModel: ViewModel {
        final class Binding: BindingObject {
            @Published var path = 0
        }

        final class Input: InputObject {
            let didTapSendButton = PassthroughSubject<DebugAPIMenuType, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var api: API?
        }

        struct API: Hashable {
            let httpMethod: String
            let requestURL: String
            let responseJSON: String?
            let responseError: String?
        }

        @BindableObject private(set) var binding: Binding

        let input: Input
        let output: Output

        private var cancellables: Set<AnyCancellable> = .init()

        init() {
            let binding = Binding()
            let input = Input()
            let output = Output()

            self.binding = binding
            self.input = input
            self.output = output

            // MARK: - API送信ボタン

            input.didTapSendButton.sink { [weak self] menuType in
                switch menuType {
                case .debugDelete:
                    self?.request(item: DebugDeleteRequest(pathComponent: binding.path))

                case .debugGet:
                    self?.request(item: DebugGetRequest(parameters: .init(userId: 1)))

                case .debugPost:
                    self?.request(item: DebugPostRequest(
                        parameters: .init(
                            userId: 1,
                            title: "title",
                            body: "body"
                        )
                    ))

                case .debugPut:
                    self?.request(item: DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "title",
                            body: "body"
                        ),
                        pathComponent: binding.path
                    ))
                }
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugAPIViewModel {
        func request(item: some Request<some Encodable>) {
            APIClient().request(item: item) { [weak self] result in
                switch result {
                case let .success(response):
                    let encoder: JSONEncoder = {
                        $0.outputFormatting = .prettyPrinted
                        return $0
                    }(JSONEncoder())

                    if let data = try? encoder.encode(response),
                       let response = String(data: data, encoding: .utf8) {
                        self?.output.api = .init(
                            httpMethod: item.method.rawValue,
                            requestURL: item.baseURL + item.path,
                            responseJSON: response,
                            responseError: nil
                        )
                    } else {
                        self?.output.api = .init(
                            httpMethod: item.method.rawValue,
                            requestURL: item.baseURL + item.path,
                            responseJSON: nil,
                            responseError: "エンコードエラーです"
                        )
                    }

                case let .failure(error):
                    self?.output.api = .init(
                        httpMethod: item.method.rawValue,
                        requestURL: item.baseURL + item.path,
                        responseJSON: nil,
                        responseError: error.errorDescription
                    )
                }
            }
        }
    }
#endif
