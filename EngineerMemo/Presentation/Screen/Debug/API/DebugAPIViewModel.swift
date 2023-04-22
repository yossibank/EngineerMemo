#if DEBUG
    import Combine
    import Foundation

    final class DebugAPIViewModel: ViewModel {
        final class Binding: BindingObject {
            @Published var menuType: DebugAPIMenuType = .debugGet
            @Published var path = -1
        }

        final class Input: InputObject {
            let didTapSendButton = PassthroughSubject<DebugAPIMenuType, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var apiInfo: APIInfo?
            @Published fileprivate(set) var apiResult: APIResult?
        }

        struct APIInfo: Hashable {
            let httpMethod: String
            let requestURL: String
        }

        struct APIResult: Hashable {
            let responseJSON: String?
            let responseError: String?
        }

        @BindableObject private(set) var binding: Binding

        let input: Input
        let output: Output

        private var item: (any Request)?
        private var cancellables: Set<AnyCancellable> = .init()

        init() {
            let binding = Binding()
            let input = Input()
            let output = Output()

            self.binding = binding
            self.input = input
            self.output = output

            // MARK: - API変更メニューボタン

            binding.$menuType.sink { [weak self] menuType in
                guard let self else {
                    return
                }

                switch menuType {
                case .debugDelete:
                    self.item = DebugDeleteRequest(pathComponent: binding.path)

                case .debugGet:
                    self.item = DebugGetRequest(parameters: .init(userId: 1))

                case .debugPost:
                    self.item = DebugPostRequest(
                        parameters: .init(
                            userId: 1,
                            title: "title",
                            body: "body"
                        )
                    )

                case .debugPut:
                    self.item = DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "title",
                            body: "body"
                        ),
                        pathComponent: binding.path
                    )
                }

                guard let item else {
                    return
                }

                output.apiInfo = .init(
                    httpMethod: item.method.rawValue,
                    requestURL: item.baseURL + item.path
                )
            }
            .store(in: &cancellables)

            // MARK: - PathComponent変更

            Publishers.CombineLatest(
                binding.$menuType,
                binding.$path
            ).sink { [weak self] menuType, path in
                guard let self else {
                    return
                }

                switch menuType {
                case .debugDelete:
                    self.item = DebugDeleteRequest(pathComponent: path)

                case .debugPut:
                    if let parameters = self.item?.parameters as? DebugPutRequest.Parameters {
                        self.item = DebugPutRequest(
                            parameters: parameters,
                            pathComponent: path
                        )
                    }

                default:
                    return
                }

                guard let item else {
                    return
                }

                output.apiInfo = .init(
                    httpMethod: item.method.rawValue,
                    requestURL: item.baseURL + item.path
                )
            }
            .store(in: &cancellables)

            // MARK: - API送信ボタン

            input.didTapSendButton.sink { [weak self] _ in
                guard
                    let self,
                    let item = self.item
                else {
                    return
                }

                self.request(item: item)
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugAPIViewModel {
        func request(item: some Request<some Codable>) {
            APIClient().request(item: item) { [weak self] result in
                switch result {
                case let .success(response):
                    let encoder: JSONEncoder = {
                        $0.outputFormatting = .prettyPrinted
                        return $0
                    }(JSONEncoder())

                    if let data = try? encoder.encode(response),
                       let response = String(data: data, encoding: .utf8) {
                        self?.output.apiResult = .init(
                            responseJSON: response,
                            responseError: nil
                        )
                    } else {
                        self?.output.apiResult = .init(
                            responseJSON: nil,
                            responseError: L10n.Debug.Api.encodeError
                        )
                    }

                case let .failure(error):
                    self?.output.apiResult = .init(
                        responseJSON: nil,
                        responseError: error.errorDescription
                    )
                }
            }
        }
    }
#endif
