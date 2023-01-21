#if DEBUG
    import Combine

    final class DebugProfileUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let addressControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let ageControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let emailControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let genderControlChanged = PassthroughSubject<DebugGenderSegment, Never>()
            let nameControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let phoneNumberControlChanged = PassthroughSubject<DebugPhoneNumberSegment, Never>()
            let stationControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let updateButtonTapped = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObject: [ProfileModelObject]?
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private var modelObject = ProfileModelObjectBuilder()
            .address(DebugCoreDataSegment.defaultString)
            .age(DebugCoreDataSegment.defaultInt)
            .email(DebugCoreDataSegment.defaultString)
            .gender(.woman)
            .name(DebugCoreDataSegment.defaultString)
            .phoneNumber(DebugPhoneNumberSegment.defaultPhoneNumber)
            .station(DebugCoreDataSegment.defaultString)
            .build()

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - プロフィール情報取得

            model.gets {
                if case let .success(modelObject) = $0 {
                    output.modelObject = modelObject
                }
            }

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
                    self?.modelObject.phoneNumber = segment.phoneNumber
                }
                .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.stationControlChanged
                .sink { [weak self] segment in
                    self?.modelObject.station = segment.string
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
                }
                .store(in: &cancellables)
        }
    }
#endif
