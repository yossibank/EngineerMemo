#if DEBUG
    import Combine

    final class DebugProfileCreateViewModel: ViewModel {
        final class Input: InputObject {
            let addressControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let ageControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let emailControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let genderControlChanged = PassthroughSubject<DebugGenderSegment, Never>()
            let nameControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let phoneNumberControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let stationControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let createButtonTapped = PassthroughSubject<Void, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private let model: ProfileModelInput

        private var cancellables: Set<AnyCancellable> = .init()
        private var modelObject = ProfileModelObjectBuilder()
            .address(DebugCoreDataSegment.defaultString)
            .age(DebugCoreDataSegment.defaultInt)
            .email(DebugCoreDataSegment.defaultString)
            .gender(.woman)
            .name(DebugCoreDataSegment.defaultString)
            .phoneNumber(DebugCoreDataSegment.defaultInt)
            .station(DebugCoreDataSegment.defaultString)
            .build()

        init(model: ProfileModelInput) {
            let input = Input()

            self.input = input
            self.model = model

            // MARK: - 住所セグメント

            input.addressControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.address = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 年齢セグメント

            input.ageControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.age = segment.int
                }
                .store(in: &cancellables)

            // MARK: - Eメールセグメント

            input.emailControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.email = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 性別セグメント

            input.genderControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.gender = segment.gender
                }
                .store(in: &cancellables)

            // MARK: - 名前セグメント

            input.nameControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.name = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 電話番号セグメント

            input.phoneNumberControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.phoneNumber = segment.int
                }
                .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.stationControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.station = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 作成ボタンタップ

            input.createButtonTapped
                .sink { [weak self] in
                    guard let self else {
                        return
                    }

                    model.create(modelObject: self.modelObject)
                }
                .store(in: &cancellables)
        }
    }
#endif
