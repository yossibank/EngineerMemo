#if DEBUG
    import Combine

    final class DebugProfileCreateViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeAddressControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeBirthdayControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeEmailControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangeGenderControl = PassthroughSubject<DebugGenderSegment, Never>()
            let didChangeNameControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didChangePhoneNumberControl = PassthroughSubject<DebugPhoneNumberSegment, Never>()
            let didChangeStationControl = PassthroughSubject<DebugCoreDataSegment, Never>()
            let didTapUpdateButton = PassthroughSubject<Void, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()

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
        private var iconImageSegment: DebugIconImageSegment = .image
        private var nameSegment: DebugCoreDataSegment = .medium
        private var phoneNumberSegment: DebugPhoneNumberSegment = .phone
        private var stationSegment: DebugCoreDataSegment = .medium

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let input = Input()

            self.input = input
            self.model = model

            // MARK: - 住所セグメント

            input.didChangeAddressControl.sink { [weak self] segment in
                self?.modelObject.address = segment.string
            }
            .store(in: &cancellables)

            // MARK: - 生年月日セグメント

            input.didChangeBirthdayControl.sink { [weak self] segment in
                self?.modelObject.birthday = segment.date
            }
            .store(in: &cancellables)

            // MARK: - Eメールセグメント

            input.didChangeEmailControl.sink { [weak self] segment in
                self?.modelObject.email = segment.string
            }
            .store(in: &cancellables)

            // MARK: - 性別セグメント

            input.didChangeGenderControl.sink { [weak self] segment in
                self?.modelObject.gender = segment.gender
            }
            .store(in: &cancellables)

            // MARK: - 名前セグメント

            input.didChangeNameControl.sink { [weak self] segment in
                self?.modelObject.name = segment.string
            }
            .store(in: &cancellables)

            // MARK: - 電話番号セグメント

            input.didChangePhoneNumberControl.sink { [weak self] segment in
                self?.modelObject.phoneNumber = segment.phoneNumber
            }
            .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.didChangeStationControl.sink { [weak self] segment in
                self?.modelObject.station = segment.string
            }
            .store(in: &cancellables)

            // MARK: - 作成ボタンタップ

            input.didTapUpdateButton.sink { [weak self] in
                guard let self else {
                    return
                }

                self.createBasic()
                self.modelObject = ProfileModelObjectBuilder()
                    .address(self.addressSegment.string)
                    .birthday(self.ageSegment.date)
                    .email(self.emailSegment.string)
                    .gender(self.genderSegment.gender)
                    .iconImage(self.iconImageSegment.image?.pngData())
                    .name(self.nameSegment.string)
                    .phoneNumber(self.phoneNumberSegment.phoneNumber)
                    .station(self.stationSegment.string)
                    .build()
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugProfileCreateViewModel {
        func createBasic() {
            model.createBasic(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
