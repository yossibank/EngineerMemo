#if DEBUG
    import Combine
    import Foundation

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
            let didChangeSkillControl = PassthroughSubject<DebugDefaultSegment, Never>()
            let didChangeProjectControl = PassthroughSubject<DebugDefaultSegment, Never>()
            let didChangeSearchText = PassthroughSubject<String, Never>()
            let didTapUpdateButton = PassthroughSubject<String, Never>()
        }

        final class Output: OutputObject {
            @Published fileprivate(set) var modelObjects: [ProfileModelObject] = []
        }

        let input: Input
        let output: Output
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()
        private var originalModelObjects: [ProfileModelObject] = []

        private var modelObject = ProfileModelObjectBuilder()
            .address(DebugCoreDataSegment.defaultString)
            .birthday(DebugCoreDataSegment.defaultDate)
            .email(DebugCoreDataSegment.defaultString)
            .gender(DebugGenderSegment.defaultGender)
            .iconImage(DebugIconImageSegment.defaultImage.pngData())
            .name(DebugCoreDataSegment.defaultString)
            .phoneNumber(DebugPhoneNumberSegment.defaultPhoneNumber)
            .station(DebugCoreDataSegment.defaultString)
            .skill(DebugDefaultSegment.defaultSkill)
            .projects(DebugDefaultSegment.defaultProjects)
            .build()

        private var addressSegment: DebugCoreDataSegment = .medium
        private var ageSegment: DebugCoreDataSegment = .medium
        private var emailSegment: DebugCoreDataSegment = .medium
        private var genderSegment: DebugGenderSegment = .woman
        private var iconImageSegment: DebugIconImageSegment = .image
        private var nameSegment: DebugCoreDataSegment = .medium
        private var phoneNumberSegment: DebugPhoneNumberSegment = .phone
        private var stationSegment: DebugCoreDataSegment = .medium
        private var skillSegment: DebugDefaultSegment = .default
        private var projectsSegment: DebugDefaultSegment = .default

        private let model: ProfileModelInput

        init(model: ProfileModelInput) {
            let input = Input()
            let output = Output()

            self.input = input
            self.output = output
            self.model = model

            // MARK: - プロフィール情報取得

            model.fetch().sink {
                if case let .failure(appError) = $0 {
                    Logger.error(message: appError.localizedDescription)
                }
            } receiveValue: { [weak self] in
                output.modelObjects = $0
                self?.originalModelObjects = $0
            }
            .store(in: &cancellables)

            // MARK: - 住所セグメント

            input.didChangeAddressControl.sink { [weak self] in
                self?.addressSegment = $0
                self?.modelObject.address = $0.string
            }
            .store(in: &cancellables)

            // MARK: - 生年月日セグメント

            input.didChangeBirthdayControl.sink { [weak self] in
                self?.ageSegment = $0
                self?.modelObject.birthday = $0.date
            }
            .store(in: &cancellables)

            // MARK: - Eメールセグメント

            input.didChangeEmailControl.sink { [weak self] in
                self?.emailSegment = $0
                self?.modelObject.email = $0.string
            }
            .store(in: &cancellables)

            // MARK: - 性別セグメント

            input.didChangeGenderControl.sink { [weak self] in
                self?.genderSegment = $0
                self?.modelObject.gender = $0.gender
            }
            .store(in: &cancellables)

            // MARK: - アイコン画像セグメント

            input.didChangeIconImageControl.sink { [weak self] in
                self?.iconImageSegment = $0
                self?.modelObject.iconImage = $0.image?.pngData()
            }
            .store(in: &cancellables)

            // MARK: - 名前セグメント

            input.didChangeNameControl.sink { [weak self] in
                self?.nameSegment = $0
                self?.modelObject.name = $0.string
            }
            .store(in: &cancellables)

            // MARK: - 電話番号セグメント

            input.didChangePhoneNumberControl.sink { [weak self] in
                self?.phoneNumberSegment = $0
                self?.modelObject.phoneNumber = $0.phoneNumber
            }
            .store(in: &cancellables)

            // MARK: - 最寄駅セグメント

            input.didChangeStationControl.sink { [weak self] in
                self?.stationSegment = $0
                self?.modelObject.station = $0.string
            }
            .store(in: &cancellables)

            // MARK: - スキルセグメント

            input.didChangeSkillControl.sink { [weak self] in
                self?.skillSegment = $0
                self?.modelObject.skill = $0.skill
            }
            .store(in: &cancellables)

            // MARK: - プロジェクトセグメント

            input.didChangeProjectControl.sink { [weak self] in
                self?.projectsSegment = $0
                self?.modelObject.projects = $0.projects
            }
            .store(in: &cancellables)

            // MARK: - 文字検索

            input.didChangeSearchText.sink { [weak self] searchText in
                guard let self else {
                    return
                }

                if searchText.isEmpty {
                    output.modelObjects = originalModelObjects
                } else {
                    output.modelObjects = originalModelObjects
                        .filter { $0.name != nil }
                        .filter { $0.name!.localizedStandardContains(searchText) }
                }
            }
            .store(in: &cancellables)

            // MARK: - 更新ボタンタップ

            input.didTapUpdateButton.sink { [weak self] in
                guard let self else {
                    return
                }

                modelObject.identifier = $0
                updateBasic()
                updateSkill()
                updateProject()
                updateIconImage()
                self.modelObject = ProfileModelObjectBuilder()
                    .address(addressSegment.string)
                    .birthday(ageSegment.date)
                    .email(emailSegment.string)
                    .gender(genderSegment.gender)
                    .iconImage(iconImageSegment.image?.pngData())
                    .name(nameSegment.string)
                    .phoneNumber(phoneNumberSegment.phoneNumber)
                    .station(stationSegment.string)
                    .skill(skillSegment.skill)
                    .projects(projectsSegment.projects)
                    .identifier($0)
                    .build()
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - private methods

    private extension DebugProfileUpdateViewModel {
        func updateBasic() {
            model.updateBasic(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }

        func updateSkill() {
            model.insertSkill(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }

        func updateProject() {
            model.createProject(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }

        func updateIconImage() {
            model.updateIconImage(modelObject)
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
#endif
