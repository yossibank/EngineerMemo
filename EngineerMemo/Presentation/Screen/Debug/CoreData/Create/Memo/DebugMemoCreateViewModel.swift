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

            // MARK: - カテゴリーセグメント

            input.didChangeCategoryControl.sink { [weak self] in
                self?.modelObject.category = $0.category
            }
            .store(in: &cancellables)

            // MARK: - タイトルセグメント

            input.didChangeTitleControl.sink { [weak self] in
                self?.modelObject.title = $0.string
            }
            .store(in: &cancellables)

            // MARK: - コンテンツセグメント

            input.didChangeContentControl.sink { [weak self] in
                self?.modelObject.content = $0.string
            }
            .store(in: &cancellables)

            // MARK: - 作成ボタンタップ

            input.didTapUpdateButton.sink { [weak self] in
                guard let self else {
                    return
                }

                createMemo()
                self.modelObject = MemoModelObjectBuilder()
                    .category(categroySegment.category)
                    .title(titleSegment.string)
                    .content(contentSegment.string)
                    .createdAt(.init())
                    .build()
            }
            .store(in: &cancellables)
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
