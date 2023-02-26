#if DEBUG
    import Combine

    final class DebugProfileUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let addressControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let birthdayControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let emailControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let genderControlChanged = PassthroughSubject<DebugGenderSegment, Never>()
            let nameControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let phoneNumberControlChanged = PassthroughSubject<DebugPhoneNumberSegment, Never>()
            let stationControlChanged = PassthroughSubject<DebugCoreDataSegment, Never>()
            let updateButtonTapped = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [ProfileModelObject]?
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var searchObject: [ProfileModelObject] = []
        private var cancellables: Set<AnyCancellable> = .init()

        private var modelObject = ProfileModelObjectBuilder()
            .address(DebugCoreDataSegment.defaultString)
            .birthday(DebugCoreDataSegment.defaultDate)
            .email(DebugCoreDataSegment.defaultString)
            .gender(DebugGenderSegment.defaultGender)
            .name(DebugCoreDataSegment.defaultString)
            .phoneNumber(DebugPhoneNumberSegment.defaultPhoneNumber)
            .station(DebugCoreDataSegment.defaultString)
            .build()

        private var addressSegment: DebugCoreDataSegment = .medium
        private var ageSegment: DebugCoreDataSegment = .medium
        private var emailSegment: DebugCoreDataSegment = .medium
        private var genderSegment: DebugGenderSegment = .woman
        private var nameSegment: DebugCoreDataSegment = .medium
        private var phoneNumberSegment: DebugPhoneNumberSegment = .phone
        private var stationSegment: DebugCoreDataSegment = .medium

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - プロフィール情報取得

            model.gets {
                if case let .success(modelObjects) = $0 {
                    output.modelObjects = modelObjects
                }
            }

            // MARK: - 住所セグメント

            input.addressControlChanged
                .sink { [weak self] segment in
                    self?.addressSegment = segment
                    self?.modelObject.address = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 生年月日セグメント

            input.birthdayControlChanged
                .sink { [weak self] segment in
                    self?.ageSegment = segment
                    self?.modelObject.birthday = segment.date
                }
                .store(in: &cancellables)

            // MARK: - Eメールセグメント

            input.emailControlChanged
                .sink { [weak self] segment in
                    self?.emailSegment = segment
                    self?.modelObject.email = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 性別セグメント

            input.genderControlChanged
                .sink { [weak self] segment in
                    self?.genderSegment = segment
                    self?.modelObject.gender = segment.gender
                }
                .store(in: &cancellables)

            // MARK: - 名前セグメント

            input.nameControlChanged
                .sink { [weak self] segment in
                    self?.nameSegment = segment
                    self?.modelObject.name = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 電話番号セグメント

            input.phoneNumberControlChanged
                .sink { [weak self] segment in
                    self?.phoneNumberSegment = segment
                    self?.modelObject.phoneNumber = segment.phoneNumber
                }
                .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.stationControlChanged
                .sink { [weak self] segment in
                    self?.stationSegment = segment
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

                    self.modelObject = ProfileModelObjectBuilder()
                        .address(self.addressSegment.string)
                        .birthday(self.ageSegment.date)
                        .email(self.emailSegment.string)
                        .gender(self.genderSegment.gender)
                        .name(self.nameSegment.string)
                        .phoneNumber(self.phoneNumberSegment.phoneNumber)
                        .station(self.stationSegment.string)
                        .identifier(identifier)
                        .build()
                }
                .store(in: &cancellables)
        }
    }
#endif
