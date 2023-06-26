#if DEBUG
    import Combine

    final class DebugMemoUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeCategoryControl = PassthroughSubject<DebugCategoryMenu, Never>()
            let didChangeTitleControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeContentControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeSearchText = PassthroughSubject<String, Never>()
            let didTapUpdateButton = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [MemoModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()
        private var originalModelObjects: [MemoModelObject] = []

        private var modelObject = MemoModelObjectBuilder()
            .category(DebugCategoryMenu.defaultCategory)
            .title(DebugCoreDataSegment.defaultString)
            .content(DebugCoreDataSegment.defaultString)
            .createdAt(.init())
            .build()

        private var categorySegment: DebugCategoryMenu = .technical
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

            model.fetch().sink {
                if case let .failure(appError) = $0 {
                    Logger.error(message: appError.localizedDescription)
                }
            } receiveValue: { [weak self] modelObjects in
                output.modelObjects = modelObjects
                self?.originalModelObjects = modelObjects
            }
            .store(in: &cancellables)

            // MARK: - カテゴリーセグメント

            input.didChangeCategoryControl.sink { [weak self] in
                self?.categorySegment = $0
                self?.modelObject.category = $0.category
            }
            .store(in: &cancellables)

            // MARK: - タイトルセグメント

            input.didChangeTitleControl.sink { [weak self] in
                self?.titleSegment = $0
                self?.modelObject.title = $0.string
            }
            .store(in: &cancellables)

            // MARK: - コンテンツセグメント

            input.didChangeContentControl.sink { [weak self] in
                self?.contentSegment = $0
                self?.modelObject.content = $0.string
            }
            .store(in: &cancellables)

            // MARK: - 文字検索

            input.didChangeSearchText.sink { [weak self] searchText in
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

            input.didTapUpdateButton.sink { [weak self] in
                guard let self else {
                    return
                }

                self.modelObject.identifier = $0
                self.updateMemo()
                self.modelObject = MemoModelObjectBuilder()
                    .category(self.categorySegment.category)
                    .title(self.titleSegment.string)
                    .content(self.contentSegment.string)
                    .createdAt(.init())
                    .build()
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugMemoUpdateViewModel {
        func updateMemo() {
            model.update(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
