#if DEBUG
    import Combine

    final class DebugMemoUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let titleControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let contentControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let searchTextChanged = PassthroughSubject<String, Never>()
            let updateButtonTapped = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [MemoModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()
        private var originalModelObjects: [MemoModelObject] = []

        private var modelObject = MemoModelObjectBuilder()
            .title(DebugCoreDataSegment.defaultString)
            .content(DebugCoreDataSegment.defaultString)
            .build()

        private var titleSegment: DebugCoreDataSegment = .medium
        private var contentSegment: DebugCoreDataSegment = .medium

        private let model: MemoModelInput

        init(model: MemoModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - メモ情報取得

            model.gets { [weak self] modelObjects in
                if case let .success(modelObjects) = modelObjects {
                    output.modelObjects = modelObjects
                    self?.originalModelObjects = modelObjects
                }
            }

            // MARK: - タイトルセグメント

            input.titleControlChanged
                .sink { [weak self] segment in
                    self?.titleSegment = segment
                    self?.modelObject.title = segment.string
                }
                .store(in: &cancellables)

            // MARK: - コンテンツセグメント

            input.contentControlChanged
                .sink { [weak self] segment in
                    self?.contentSegment = segment
                    self?.modelObject.content = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 文字検索

            input.searchTextChanged
                .sink { [weak self] searchText in
                    guard let self else {
                        return
                    }

                    if searchText.isEmpty {
                        output.modelObjects = self.originalModelObjects
                    } else {
                        output.modelObjects = self.originalModelObjects
                            .filter { $0.title != nil }
                            .filter { $0.title!.localizedStandardContains(searchText) }
                    }
                }
                .store(in: &cancellables)

            // MARK: - 更新ボタンタップ

            input.updateButtonTapped
                .sink { [weak self] identifier in
                    guard let self else {
                        return
                    }

                    self.modelObject.identifier = identifier
                    self.model.update(modelObject: self.modelObject)

                    self.modelObject = MemoModelObjectBuilder()
                        .title(self.titleSegment.string)
                        .content(self.contentSegment.string)
                        .build()
                }
                .store(in: &cancellables)
        }
    }
#endif
