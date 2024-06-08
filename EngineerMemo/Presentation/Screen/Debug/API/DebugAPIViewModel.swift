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
        private var cancellables = Set<AnyCancellable>()

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

            binding.$menuType.weakSink(with: self, cancellables: &cancellables) {
                switch $1 {
                case .debugDelete:
                    $0.item = DebugDeleteRequest(pathComponent: binding.path)

                case .debugGet:
                    $0.item = DebugGetRequest(
                        parameters: .init(userId: $0.parameters.userId)
                    )

                case .debugPost:
                    $0.item = DebugPostRequest(
                        parameters: .init(
                            userId: $0.parameters.userId ?? 1,
                            title: $0.parameters.title ?? .empty,
                            body: $0.parameters.body ?? .empty
                        )
                    )

                case .debugPut:
                    $0.item = DebugPutRequest(
                        parameters: .init(
                            userId: $0.parameters.userId ?? 1,
                            id: $0.parameters.id ?? 1,
                            title: $0.parameters.title ?? .empty,
                            body: $0.parameters.body ?? .empty
                        ),
                        pathComponent: binding.path
                    )
                }

                guard let item = $0.item else {
                    return
                }

                output.apiInfo = .init(
                    httpMethod: item.method.rawValue,
                    requestURL: item.baseURL + item.path
                )
            }

            // MARK: - PathComponent変更

            binding.$path
                .withLatestFrom(menuType) { ($0, $1) }
                .weakSink(with: self, cancellables: &cancellables) {
                    switch $1.1 {
                    case .debugDelete:
                        $0.item = DebugDeleteRequest(pathComponent: $1.0)

                    case .debugPut:
                        if let parameters = $0.item?.parameters as? DebugPutRequest.Parameters {
                            $0.item = DebugPutRequest(
                                parameters: parameters,
                                pathComponent: $1.0
                            )
                        }

                    default:
                        return
                    }

                    guard let item = $0.item else {
                        return
                    }

                    output.apiInfo = .init(
                        httpMethod: item.method.rawValue,
                        requestURL: item.baseURL + item.path
                    )
                }

            // MARK: - Parameters変更

            binding.$userId.weakSink(with: self, cancellables: &cancellables) {
                $0.parameters.userId = $1
            }

            binding.$id.weakSink(with: self, cancellables: &cancellables) {
                $0.parameters.id = $1
            }

            binding.$title.weakSink(with: self, cancellables: &cancellables) {
                $0.parameters.title = $1
            }

            binding.$body.weakSink(with: self, cancellables: &cancellables) {
                $0.parameters.body = $1
            }

            // MARK: - API送信ボタン

            input.didTapSendButton
                .withLatestFrom(menuType) { ($0, $1) }
                .weakSink(with: self, cancellables: &cancellables) {
                    switch $1.1 {
                    case .debugDelete:
                        break

                    case .debugGet:
                        $0.item = DebugGetRequest(
                            parameters: .init(userId: $0.parameters.userId)
                        )

                    case .debugPost:
                        $0.item = DebugPostRequest(
                            parameters: .init(
                                userId: $0.parameters.userId ?? 1,
                                title: $0.parameters.title ?? .empty,
                                body: $0.parameters.body ?? .empty
                            )
                        )

                    case .debugPut:
                        $0.item = DebugPutRequest(
                            parameters: .init(
                                userId: $0.parameters.userId ?? 1,
                                id: $0.parameters.id ?? 1,
                                title: $0.parameters.title ?? .empty,
                                body: $0.parameters.body ?? .empty
                            ),
                            pathComponent: binding.path
                        )
                    }

                    guard let item = $0.item else {
                        return
                    }

                    $0.request(item: item)
                }

            menuType
                .connect()
                .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugAPIViewModel {
        func request(item: some Request<some Encodable>) {
            output.isLoading = true

            APIClient().request(item: item).sink(
                receiveCompletion: { [weak self] in
                    guard let self else {
                        return
                    }

                    if case let .failure(appError) = $0 {
                        output.apiResult = .init(
                            responseJSON: nil,
                            responseError: appError.localizedDescription
                        )
                        output.isLoading = false
                    }
                },
                receiveValue: { [weak self] in
                    guard let self else {
                        return
                    }

                    let encoder: JSONEncoder = {
                        $0.outputFormatting = .prettyPrinted
                        return $0
                    }(JSONEncoder())

                    guard
                        let data = try? encoder.encode($0),
                        let response = String(data: data, encoding: .utf8)
                    else {
                        output.apiResult = .init(
                            responseJSON: nil,
                            responseError: L10n.Debug.Api.encodeError
                        )
                        output.isLoading = false
                        return
                    }

                    output.apiResult = .init(
                        responseJSON: response,
                        responseError: nil
                    )
                    output.isLoading = false
                }
            )
            .store(in: &cancellables)
        }
    }
#endif
