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

            cancellables.formUnion([
                // MARK: - メモ情報取得

                model.fetch().sink {
                    if case let .failure(appError) = $0 {
                        Logger.error(message: appError.localizedDescription)
                    }
                } receiveValue: { [weak self] modelObjects in
                    output.modelObjects = modelObjects
                    self?.originalModelObjects = modelObjects
                },

                // MARK: - カテゴリーセグメント

                input.didChangeCategoryControl.weakSink(with: self) {
                    $0.categorySegment = $1
                    $0.modelObject.category = $1.category
                },

                // MARK: - タイトルセグメント

                input.didChangeTitleControl.weakSink(with: self) {
                    $0.titleSegment = $1
                    $0.modelObject.title = $1.string
                },

                // MARK: - コンテンツセグメント

                input.didChangeContentControl.weakSink(with: self) {
                    $0.contentSegment = $1
                    $0.modelObject.content = $1.string
                },

                // MARK: - 文字検索

                input.didChangeSearchText.weakSink(with: self) { instance, searchText in
                    if searchText.isEmpty {
                        output.modelObjects = instance.originalModelObjects
                    } else {
                        output.modelObjects = instance.originalModelObjects
                            .filter { $0.title != nil }
                            .filter { $0.title!.localizedStandardContains(searchText) }
                    }
                },

                // MARK: - 更新ボタンタップ

                input.didTapUpdateButton.weakSink(with: self) {
                    $0.modelObject.identifier = $1
                    $0.updateMemo()
                    $0.modelObject = MemoModelObjectBuilder()
                        .category($0.categorySegment.category)
                        .title($0.titleSegment.string)
                        .content($0.contentSegment.string)
                        .createdAt(.init())
                        .build()
                }
            ])
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
