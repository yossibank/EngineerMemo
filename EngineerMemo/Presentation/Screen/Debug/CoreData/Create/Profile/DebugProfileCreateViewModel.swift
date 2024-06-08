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

            cancellables.formUnion([
                // MARK: - 住所セグメント

                input.didChangeAddressControl.weakSink(with: self) {
                    $0.modelObject.address = $1.string
                },

                // MARK: - 生年月日セグメント

                input.didChangeBirthdayControl.weakSink(with: self) {
                    $0.modelObject.birthday = $1.date
                },

                // MARK: - Eメールセグメント

                input.didChangeEmailControl.weakSink(with: self) {
                    $0.modelObject.email = $1.string
                },

                // MARK: - 性別セグメント

                input.didChangeGenderControl.weakSink(with: self) {
                    $0.modelObject.gender = $1.gender
                },

                // MARK: - 名前セグメント

                input.didChangeNameControl.weakSink(with: self) {
                    $0.modelObject.name = $1.string
                },

                // MARK: - 電話番号セグメント

                input.didChangePhoneNumberControl.weakSink(with: self) {
                    $0.modelObject.phoneNumber = $1.phoneNumber
                },

                // MARK: - 最寄駅セグメント

                input.didChangeStationControl.weakSink(with: self) {
                    $0.modelObject.station = $1.string
                },

                // MARK: - 作成ボタンタップ

                input.didTapUpdateButton.weakSink(with: self) {
                    $0.createBasic()
                    $0.modelObject = ProfileModelObjectBuilder()
                        .address($0.addressSegment.string)
                        .birthday($0.ageSegment.date)
                        .email($0.emailSegment.string)
                        .gender($0.genderSegment.gender)
                        .iconImage($0.iconImageSegment.image?.pngData())
                        .name($0.nameSegment.string)
                        .phoneNumber($0.phoneNumberSegment.phoneNumber)
                        .station($0.stationSegment.string)
                        .build()
                }
            ])
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
