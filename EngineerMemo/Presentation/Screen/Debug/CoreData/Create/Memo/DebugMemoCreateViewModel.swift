#if DEBUG
    import Combine

    final class DebugMemoCreateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeCategoryControl = PassthroughSubject<DebugCategoryMenu, Never>()
            let didChangeTitleControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeContentControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didTapUpdateButton = PassthroughSubject<Void, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()

        private var modelObject = MemoModelObjectBuilder()
            .category(DebugCategoryMenu.defaultCategory)
            .title(DebugCoreDataSegment.defaultString)
            .content(DebugCoreDataSegment.defaultString)
            .createdAt(.init())
            .build()

        private var categroySegment: DebugCategoryMenu = .technical
        private var titleSegment: DebugCoreDataSegment = .medium
        private var contentSegment: DebugCoreDataSegment = .medium

        private let model: MemoModelInput

        init(model: MemoModelInput) {
            let input = Input()

            self.input = input
            self.model = model

            cancellables.formUnion([
                // MARK: - カテゴリーセグメント

                input.didChangeCategoryControl.weakSink(with: self) {
                    $0.modelObject.category = $1.category
                },

                // MARK: - タイトルセグメント

                input.didChangeTitleControl.weakSink(with: self) {
                    $0.modelObject.title = $1.string
                },

                // MARK: - コンテンツセグメント

                input.didChangeContentControl.weakSink(with: self) {
                    $0.modelObject.content = $1.string
                },

                // MARK: - 作成ボタンタップ

                input.didTapUpdateButton.weakSink(with: self) {
                    $0.createMemo()
                    $0.modelObject = MemoModelObjectBuilder()
                        .category($0.categroySegment.category)
                        .title($0.titleSegment.string)
                        .content($0.contentSegment.string)
                        .createdAt(.init())
                        .build()
                }
            ])
        }
    }

    // MARK: - private methods

    private extension DebugMemoCreateViewModel {
        func createMemo() {
            model.create(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
