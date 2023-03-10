#if DEBUG
    import Combine

    final class DebugMemoCreateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeTitleControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeContentControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didTapCreateButton = PassthroughSubject<Void, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private var modelObject = MemoModelObjectBuilder()
            .title(DebugCoreDataSegment.defaultString)
            .content(DebugCoreDataSegment.defaultString)
            .build()

        private let model: MemoModelInput

        init(model: MemoModelInput) {
            let input = Input()

            self.input = input
            self.model = model

            // MARK: - タイトルセグメント

            input.didChangeTitleControl
                .sink { [weak self] segment in
                    self?.modelObject.title = segment.string
                }
                .store(in: &cancellables)

            // MARK: - コンテンツセグメント

            input.didChangeContentControl
                .sink { [weak self] segment in
                    self?.modelObject.content = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 作成ボタンタップ

            input.didTapCreateButton
                .sink { [weak self] in
                    guard let self else {
                        return
                    }

                    self.model.create(modelObject: self.modelObject)
                }
                .store(in: &cancellables)
        }
    }
#endif
