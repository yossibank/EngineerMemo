#if DEBUG
    import Combine

    final class DebugProfileUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeAddressControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeBirthdayControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeEmailControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeGenderControl = PassthroughSubject<DebugGenderSegment, Never>()
            let didChangeIconImageControl = PassthroughSubject<DebugIconImageSegment, Never>()
            let didChangeNameControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangePhoneNumberControl = PassthroughSubject<DebugPhoneNumberSegment, Never>()
            let didChangeStationControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeSearchText = PassthroughSubject<String, Never>()
            let didTapUpdateButton = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [ProfileModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()
        private var originalModelObjects: [ProfileModelObject] = []

        private var modelObject = ProfileModelObjectBuilder()
            .address(DebugCoreDataSegment.defaultString)
            .birthday(DebugCoreDataSegment.defaultDate)
            .email(DebugCoreDataSegment.defaultString)
            .gender(DebugGenderSegment.defaultGender)
            .iconImage(DebugIconImageSegment.defaultImage?.pngData())
            .name(DebugCoreDataSegment.defaultString)
            .phoneNumber(DebugPhoneNumberSegment.defaultPhoneNumber)
            .station(DebugCoreDataSegment.defaultString)
            .build()

        private var addressSegment: DebugCoreDataSegment = .medium
        private var ageSegment: DebugCoreDataSegment = .medium
        private var emailSegment: DebugCoreDataSegment = .medium
        private var genderSegment: DebugGenderSegment = .woman
        private var iconImageSegment: DebugIconImageSegment = .image
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

            model.gets { [weak self] modelObjects in
                if case let .success(modelObjects) = modelObjects {
                    output.modelObjects = modelObjects
                    self?.originalModelObjects = modelObjects
                }
            }

            // MARK: - 住所セグメント

            input.didChangeAddressControl
                .sink { [weak self] segment in
                    self?.addressSegment = segment
                    self?.modelObject.address = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 生年月日セグメント

            input.didChangeBirthdayControl
                .sink { [weak self] segment in
                    self?.ageSegment = segment
                    self?.modelObject.birthday = segment.date
                }
                .store(in: &cancellables)

            // MARK: - Eメールセグメント

            input.didChangeEmailControl
                .sink { [weak self] segment in
                    self?.emailSegment = segment
                    self?.modelObject.email = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 性別セグメント

            input.didChangeGenderControl
                .sink { [weak self] segment in
                    self?.genderSegment = segment
                    self?.modelObject.gender = segment.gender
                }
                .store(in: &cancellables)

            // MARK: - アイコン画像セグメント

            input.didChangeIconImageControl
                .sink { [weak self] segment in
                    self?.iconImageSegment = segment
                    self?.modelObject.iconImage = segment.image?.pngData()
                }
                .store(in: &cancellables)

            // MARK: - 名前セグメント

            input.didChangeNameControl
                .sink { [weak self] segment in
                    self?.nameSegment = segment
                    self?.modelObject.name = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 電話番号セグメント

            input.didChangePhoneNumberControl
                .sink { [weak self] segment in
                    self?.phoneNumberSegment = segment
                    self?.modelObject.phoneNumber = segment.phoneNumber
                }
                .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.didChangeStationControl
                .sink { [weak self] segment in
                    self?.stationSegment = segment
                    self?.modelObject.station = segment.string
                }
                .store(in: &cancellables)

            // MARK: - 文字検索

            input.didChangeSearchText
                .sink { [weak self] searchText in
                    guard let self else {
                        return
                    }

                    if searchText.isEmpty {
                        output.modelObjects = self.originalModelObjects
                    } else {
                        output.modelObjects = self.originalModelObjects
                            .filter { $0.name != nil }
                            .filter { $0.name!.localizedStandardContains(searchText) }
                    }
                }
                .store(in: &cancellables)

            // MARK: - 更新ボタンタップ

            input.didTapUpdateButton
                .sink { [weak self] identifier in
                    guard let self else {
                        return
                    }

                    self.modelObject.identifier = identifier
                    self.model.update(modelObject: self.modelObject)
                    self.model.iconImageUpdate(modelObject: self.modelObject)
                    self.modelObject = ProfileModelObjectBuilder()
                        .address(self.addressSegment.string)
                        .birthday(self.ageSegment.date)
                        .email(self.emailSegment.string)
                        .gender(self.genderSegment.gender)
                        .iconImage(self.iconImageSegment.image?.pngData())
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
