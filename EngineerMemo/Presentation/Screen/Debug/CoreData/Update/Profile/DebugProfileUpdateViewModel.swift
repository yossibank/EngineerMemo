#if DEBUG
    import Combine

    final class DebugProfileUpdateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeAddressControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeBirthdayControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeEmailControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeGenderControl = PassthroughSubject<DebugGenderSegment, Never>()
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

            // MARK: - ??????????????????????????????

            model.gets { [weak self] modelObjects in
                if case let .success(modelObjects) = modelObjects {
                    output.modelObjects = modelObjects
                    self?.originalModelObjects = modelObjects
                }
            }

            // MARK: - ?????????????????????

            input.didChangeAddressControl
                .sink { [weak self] segment in
                    self?.addressSegment = segment
                    self?.modelObject.address = segment.string
                }
                .store(in: &cancellables)

            // MARK: - ???????????????????????????

            input.didChangeBirthdayControl
                .sink { [weak self] segment in
                    self?.ageSegment = segment
                    self?.modelObject.birthday = segment.date
                }
                .store(in: &cancellables)

            // MARK: - E????????????????????????

            input.didChangeEmailControl
                .sink { [weak self] segment in
                    self?.emailSegment = segment
                    self?.modelObject.email = segment.string
                }
                .store(in: &cancellables)

            // MARK: - ?????????????????????

            input.didChangeGenderControl
                .sink { [weak self] segment in
                    self?.genderSegment = segment
                    self?.modelObject.gender = segment.gender
                }
                .store(in: &cancellables)

            // MARK: - ?????????????????????

            input.didChangeNameControl
                .sink { [weak self] segment in
                    self?.nameSegment = segment
                    self?.modelObject.name = segment.string
                }
                .store(in: &cancellables)

            // MARK: - ???????????????????????????

            input.didChangePhoneNumberControl
                .sink { [weak self] segment in
                    self?.phoneNumberSegment = segment
                    self?.modelObject.phoneNumber = segment.phoneNumber
                }
                .store(in: &cancellables)

            // MARK: - ????????????????????????

            input.didChangeStationControl
                .sink { [weak self] segment in
                    self?.stationSegment = segment
                    self?.modelObject.station = segment.string
                }
                .store(in: &cancellables)

            // MARK: - ????????????

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

            // MARK: - ????????????????????????

            input.didTapUpdateButton
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
