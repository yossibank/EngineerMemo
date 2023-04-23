#if DEBUG
    import Combine
    import Foundation

    final class DebugAPIViewModel: ViewModel {
        final class Binding: BindingObject {
            @Published var menuType: DebugAPIMenuType = .debugGet
            @Published var path: Int = .zero
            @Published var userId: Int?
            @Published var id: Int = .zero
            @Published var title: String = .empty
            @Published var body: String = .empty
        }

        final class Input: InputObject {
            let didTapSendButton = PassthroughSubject<DebugAPIMenuType, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var isLoading = false
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

        struct APIDebugParameters {
            var userId: Int?
            var id: Int?
            var title: String?
            var body: String?
        }

        enum Parameters {
            case userId
            case id
            case title
            case body
        }

        @BindableObject private(set) var binding: Binding

        let input: Input
        let output: Output

        private var item: (any Request)?
        private var parameters: APIDebugParameters = .init()
        private var cancellables: Set<AnyCancellable> = .init()

        init() {
            let binding = Binding()
            let input = Input()
            let output = Output()

            self.binding = binding
            self.input = input
            self.output = output

            let menuType = binding.$menuType
                .multicast(subject: PassthroughSubject<DebugAPIMenuType, Never>())

            // MARK: - API変更メニューボタン

            binding.$menuType.sink { [weak self] menuType in
                guard let self else {
                    return
                }

                switch menuType {
                case .debugDelete:
                    self.item = DebugDeleteRequest(
                        pathComponent: binding.path
                    )

                case .debugGet:
                    self.item = DebugGetRequest(
                        parameters: .init(userId: self.parameters.userId)
                    )

                case .debugPost:
                    self.item = DebugPostRequest(
                        parameters: .init(
                            userId: self.parameters.userId ?? 1,
                            title: self.parameters.title ?? .empty,
                            body: self.parameters.body ?? .empty
                        )
                    )

                case .debugPut:
                    self.item = DebugPutRequest(
                        parameters: .init(
                            userId: self.parameters.userId ?? 1,
                            id: self.parameters.id ?? 1,
                            title: self.parameters.title ?? .empty,
                            body: self.parameters.body ?? .empty
                        ),
                        pathComponent: binding.path
                    )
                }

                guard let item = self.item else {
                    return
                }

                output.apiInfo = .init(
                    httpMethod: item.method.rawValue,
                    requestURL: item.baseURL + item.path
                )
            }
            .store(in: &cancellables)

            // MARK: - PathComponent変更

            binding.$path
                .withLatestFrom(menuType) { ($0, $1) }
                .sink { [weak self] path, menuType in
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

            // MARK: - Parameters変更

            binding.$userId.sink { [weak self] userId in
                self?.parameters.userId = userId
            }
            .store(in: &cancellables)

            binding.$id.sink { [weak self] id in
                self?.parameters.id = id
            }
            .store(in: &cancellables)

            binding.$title.sink { [weak self] title in
                self?.parameters.title = title
            }
            .store(in: &cancellables)

            binding.$body.sink { [weak self] body in
                self?.parameters.body = body
            }
            .store(in: &cancellables)

            // MARK: - API送信ボタン

            input.didTapSendButton
                .withLatestFrom(menuType) { ($0, $1) }
                .sink { [weak self] _, menuType in
                    guard let self else {
                        return
                    }

                    switch menuType {
                    case .debugDelete:
                        break

                    case .debugGet:
                        self.item = DebugGetRequest(
                            parameters: .init(userId: self.parameters.userId)
                        )

                    case .debugPost:
                        self.item = DebugPostRequest(
                            parameters: .init(
                                userId: self.parameters.userId ?? 1,
                                title: self.parameters.title ?? .empty,
                                body: self.parameters.body ?? .empty
                            )
                        )

                    case .debugPut:
                        self.item = DebugPutRequest(
                            parameters: .init(
                                userId: self.parameters.userId ?? 1,
                                id: self.parameters.id ?? 1,
                                title: self.parameters.title ?? .empty,
                                body: self.parameters.body ?? .empty
                            ),
                            pathComponent: binding.path
                        )
                    }

                    guard let item else {
                        return
                    }

                    self.request(item: item)
                }
                .store(in: &cancellables)

            menuType
                .connect()
                .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugAPIViewModel {
        func request(item: some Request<some Encodable>) {
            output.isLoading = true

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
                        self?.output.isLoading = false
                    } else {
                        self?.output.apiResult = .init(
                            responseJSON: nil,
                            responseError: L10n.Debug.Api.encodeError
                        )
                        self?.output.isLoading = false
                    }

                case let .failure(error):
                    self?.output.apiResult = .init(
                        responseJSON: nil,
                        responseError: error.errorDescription
                    )
                    self?.output.isLoading = false
                }
            }
        }
    }
#endif
