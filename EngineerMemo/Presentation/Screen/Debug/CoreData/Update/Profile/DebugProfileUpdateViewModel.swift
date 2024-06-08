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

            cancellables.formUnion([
                // MARK: - プロフィール情報取得

                model.fetch().sink {
                    if case let .failure(appError) = $0 {
                        Logger.error(message: appError.localizedDescription)
                    }
                } receiveValue: { [weak self] in
                    output.modelObjects = $0
                    self?.originalModelObjects = $0
                },

                // MARK: - 住所セグメント

                input.didChangeAddressControl.weakSink(with: self) {
                    $0.addressSegment = $1
                    $0.modelObject.address = $1.string
                },

                // MARK: - 生年月日セグメント

                input.didChangeBirthdayControl.weakSink(with: self) {
                    $0.ageSegment = $1
                    $0.modelObject.birthday = $1.date
                },

                // MARK: - Eメールセグメント

                input.didChangeEmailControl.weakSink(with: self) {
                    $0.emailSegment = $1
                    $0.modelObject.email = $1.string
                },

                // MARK: - 性別セグメント

                input.didChangeGenderControl.weakSink(with: self) {
                    $0.genderSegment = $1
                    $0.modelObject.gender = $1.gender
                },

                // MARK: - アイコン画像セグメント

                input.didChangeIconImageControl.weakSink(with: self) {
                    $0.iconImageSegment = $1
                    $0.modelObject.iconImage = $1.image?.pngData()
                },

                // MARK: - 名前セグメント

                input.didChangeNameControl.weakSink(with: self) {
                    $0.nameSegment = $1
                    $0.modelObject.name = $1.string
                },

                // MARK: - 電話番号セグメント

                input.didChangePhoneNumberControl.weakSink(with: self) {
                    $0.phoneNumberSegment = $1
                    $0.modelObject.phoneNumber = $1.phoneNumber
                },

                // MARK: - 最寄駅セグメント

                input.didChangeStationControl.weakSink(with: self) {
                    $0.stationSegment = $1
                    $0.modelObject.station = $1.string
                },

                // MARK: - スキルセグメント

                input.didChangeSkillControl.weakSink(with: self) {
                    $0.skillSegment = $1
                    $0.modelObject.skill = $1.skill
                },

                // MARK: - プロジェクトセグメント

                input.didChangeProjectControl.weakSink(with: self) {
                    $0.projectsSegment = $1
                    $0.modelObject.projects = $1.projects
                },

                // MARK: - 文字検索

                input.didChangeSearchText.weakSink(with: self) { instance, searchText in
                    if searchText.isEmpty {
                        output.modelObjects = instance.originalModelObjects
                    } else {
                        output.modelObjects = instance.originalModelObjects
                            .filter { $0.name != nil }
                            .filter { $0.name!.localizedStandardContains(searchText) }
                    }
                },

                // MARK: - 更新ボタンタップ

                input.didTapUpdateButton.weakSink(with: self) {
                    $0.modelObject.identifier = $1
                    $0.updateBasic()
                    $0.updateSkill()
                    $0.updateProject()
                    $0.updateIconImage()
                    $0.modelObject = ProfileModelObjectBuilder()
                        .address($0.addressSegment.string)
                        .birthday($0.ageSegment.date)
                        .email($0.emailSegment.string)
                        .gender($0.genderSegment.gender)
                        .iconImage($0.iconImageSegment.image?.pngData())
                        .name($0.nameSegment.string)
                        .phoneNumber($0.phoneNumberSegment.phoneNumber)
                        .station($0.stationSegment.string)
                        .skill($0.skillSegment.skill)
                        .projects($0.projectsSegment.projects)
                        .identifier($1)
                        .build()
                }
            ])
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
