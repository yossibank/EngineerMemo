import Combine
@testable import EngineerMemo
import XCTest

final class ProfileModelTest: XCTestCase {
    private var profileConverter: ProfileConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: ProfileModel!
    private var cancellables = Set<AnyCancellable>()

    private let storage = CoreDataStorage<Profile>()

    override func setUp() {
        super.setUp()

        profileConverter = .init()
        errorConverter = .init()
        model = .init(
            profileConverter: profileConverter,
            errorConverter: errorConverter
        )
    }

    override func tearDown() {
        super.tearDown()

        profileConverter = nil
        errorConverter = nil
        model = nil

        cancellables.removeAll()

        resetUserDefaults()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_fetch_プロフィール情報を取得できること() throws {
        // arrange
        dataInsert()

        profileConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.address, "テスト県テスト市テスト1-1-1")
            XCTAssertEqual($0.birthday, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual($0.email, "test@test.com")
            XCTAssertEqual($0.gender, .man)
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.name, "testName")
            XCTAssertEqual($0.phoneNumber, "08011112222")
            XCTAssertEqual($0.station, "鶴橋駅")

            return ProfileModelObjectBuilder()
                .address($0.address!)
                .birthday($0.birthday!)
                .email($0.email!)
                .gender(.init(rawValue: $0.gender!.rawValue)!)
                .name($0.name!)
                .phoneNumber($0.phoneNumber!)
                .station($0.station!)
                .build()
        }

        let publisher = model.fetch().dropFirst().collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertEqual(
            output,
            [
                ProfileModelObjectBuilder()
                    .address("テスト県テスト市テスト1-1-1")
                    .birthday(Calendar.date(year: 2000, month: 1, day: 1))
                    .email("test@test.com")
                    .gender(.man)
                    .identifier("identifier")
                    .name("testName")
                    .phoneNumber("08011112222")
                    .station("鶴橋駅")
                    .build()
            ]
        )
    }

    func test_find_プロフィール情報を取得できること() throws {
        // arrange
        dataInsert()

        profileConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.address, "テスト県テスト市テスト1-1-1")
            XCTAssertEqual($0.birthday, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual($0.email, "test@test.com")
            XCTAssertEqual($0.gender, .man)
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.name, "testName")
            XCTAssertEqual($0.phoneNumber, "08011112222")
            XCTAssertEqual($0.station, "鶴橋駅")

            return ProfileModelObjectBuilder()
                .address($0.address!)
                .birthday($0.birthday!)
                .email($0.email!)
                .gender(.init(rawValue: $0.gender!.rawValue)!)
                .name($0.name!)
                .phoneNumber($0.phoneNumber!)
                .station($0.station!)
                .build()
        }

        let publisher = model.find(identifier: "identifier").collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertEqual(
            output,
            ProfileModelObjectBuilder()
                .address("テスト県テスト市テスト1-1-1")
                .birthday(Calendar.date(year: 2000, month: 1, day: 1))
                .email("test@test.com")
                .gender(.man)
                .identifier("identifier")
                .name("testName")
                .phoneNumber("08011112222")
                .station("鶴橋駅")
                .build()
        )
    }

    func test_createBasic_基本情報を作成できること() throws {
        // act
        let publisher = model.createBasic(
            ProfileModelObjectBuilder()
                .name("テスト")
                .birthday(Calendar.date(year: 2000, month: 1, day: 1))
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!

                // assert
                XCTAssertEqual(profile.name, "テスト")
                XCTAssertEqual(profile.birthday, Calendar.date(year: 2000, month: 1, day: 1))

                expectation.fulfill()
            }
        }
    }

    func test_createBasic_DataHolder_isShowAppReviewがtrueを出力すること() throws {
        // assert
        XCTAssertFalse(DataHolder.isShowAppReview)

        // act
        let publisher = model.createBasic(
            ProfileModelObjectBuilder()
                .name("テスト")
                .birthday(Calendar.date(year: 2000, month: 1, day: 1))
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        XCTAssertTrue(DataHolder.isShowAppReview)
    }

    func test_updateBasic_基本情報を更新できること() throws {
        // arrange
        dataInsert()

        // act
        let publisher = model.updateBasic(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .name("テスト更新後")
                .birthday(Calendar.date(year: 2000, month: 11, day: 1))
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!

                // assert
                XCTAssertEqual(profile.name, "テスト更新後")
                XCTAssertEqual(profile.birthday, Calendar.date(year: 2000, month: 11, day: 1))

                expectation.fulfill()
            }
        }
    }

    func test_insertSkill_スキル情報を作成できること() throws {
        // arrange
        dataInsert()

        // act
        let publisher = model.insertSkill(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .skill(
                    SKillModelObjectBuilder()
                        .engineerCareer(3)
                        .identifier("identifier")
                        .language("Swift")
                        .languageCareer(2)
                        .toeic(600)
                        .pr("PR事項")
                        .build()
                )
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!
                let skill = profile.skill!

                // assert
                XCTAssertEqual(skill.engineerCareer, 3)
                XCTAssertEqual(skill.language, "Swift")
                XCTAssertEqual(skill.languageCareer, 2)
                XCTAssertEqual(skill.toeic, 600)
                XCTAssertEqual(skill.pr, "PR事項")

                expectation.fulfill()
            }
        }
    }

    func test_insertSkill_スキル情報を更新できること() throws {
        // arrange
        dataInsert(
            skill: SkillDataObjectBuilder()
                .engineerCareer(5)
                .language("Kotlin")
                .languageCareer(8)
                .toeic(400)
                .pr("PR事項1")
                .build()
        )

        // act
        let publisher = model.insertSkill(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .skill(
                    SKillModelObjectBuilder()
                        .engineerCareer(10)
                        .language("Swift")
                        .languageCareer(2)
                        .identifier("identifier")
                        .toeic(600)
                        .pr("PR事項2")
                        .build()
                )
                .build()
        )

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!
                let skill = profile.skill!

                // assert
                XCTAssertEqual(skill.engineerCareer, 10)
                XCTAssertEqual(skill.language, "Swift")
                XCTAssertEqual(skill.languageCareer, 2)
                XCTAssertEqual(skill.toeic, 600)
                XCTAssertEqual(skill.pr, "PR事項2")

                expectation.fulfill()
            }
        }
    }

    func test_deleteSkill_スキル情報を削除できること() throws {
        // arrange
        dataInsert(
            skill: SkillDataObjectBuilder()
                .engineerCareer(5)
                .language("Swift")
                .languageCareer(2)
                .pr("PR事項")
                .build()
        )

        // act
        let publisher = model.deleteSkill(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .skill(nil)
                .build()
        )

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!

                // assert
                XCTAssertNil(profile.skill)

                expectation.fulfill()
            }
        }
    }

    func test_createProject_案件情報を作成できること() throws {
        // arrange
        dataInsert()

        // act
        let publisher = model.createProject(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .projects([
                    ProjectModelObjectBuilder()
                        .identifier("identifier")
                        .title("title")
                        .role("プログラマー")
                        .processes([.functionalDesign, .implementation, .intergrationTesting])
                        .language("Swift")
                        .database("CoreData")
                        .serverOS("Ubuntu")
                        .tools(["Firebase", "MagicPod"])
                        .content("content")
                        .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                        .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                        .build()
                ])
                .build()
        )

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!
                let project = profile.projects?.allObjects.first as! Project

                // assert
                XCTAssertEqual(project.title, "title")
                XCTAssertEqual(project.role, "プログラマー")
                XCTAssertEqual(project.processes, [1, 3, 4])
                XCTAssertEqual(project.language, "Swift")
                XCTAssertEqual(project.database, "CoreData")
                XCTAssertEqual(project.serverOS, "Ubuntu")
                XCTAssertEqual(project.tools, ["Firebase", "MagicPod"])
                XCTAssertEqual(project.content, "content")
                XCTAssertEqual(project.startDate, Calendar.date(year: 2020, month: 1, day: 1))
                XCTAssertEqual(project.endDate, Calendar.date(year: 2021, month: 12, day: 1))

                expectation.fulfill()
            }
        }
    }

    func test_updateProject_案件情報を更新できること() throws {
        // arrange
        dataInsert(
            projects: [
                ProjectDataObjectBuilder()
                    .content("content")
                    .database("sqlite3")
                    .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                    .identifier("identifier")
                    .language("Kotlin")
                    .processes([1, 3, 5])
                    .role("プログラマー")
                    .serverOS("linux")
                    .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                    .title("title")
                    .tools(["Firebase"])
                    .build()
            ]
        )

        // act
        let publisher = model.updateProject(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .projects([
                    ProjectModelObjectBuilder()
                        .identifier("identifier")
                        .title("update title")
                        .processes([.functionalDesign, .implementation, .systemTesting, .maintenance])
                        .role("PG")
                        .language("Swift")
                        .database("CoreData")
                        .serverOS("Ubuntu")
                        .tools(["Firebase", "MagicPod"])
                        .content("update content")
                        .startDate(Calendar.date(year: 2019, month: 1, day: 1))
                        .endDate(Calendar.date(year: 2022, month: 1, day: 1))
                        .build()
                ])
                .build(),
            identifier: "identifier"
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!
                let project = profile.projects?.allObjects.first as! Project

                // assert
                XCTAssertEqual(project.title, "update title")
                XCTAssertEqual(project.role, "PG")
                XCTAssertEqual(project.processes, [1, 3, 5, 6])
                XCTAssertEqual(project.language, "Swift")
                XCTAssertEqual(project.database, "CoreData")
                XCTAssertEqual(project.serverOS, "Ubuntu")
                XCTAssertEqual(project.tools, ["Firebase", "MagicPod"])
                XCTAssertEqual(project.content, "update content")
                XCTAssertEqual(project.startDate, Calendar.date(year: 2019, month: 1, day: 1))
                XCTAssertEqual(project.endDate, Calendar.date(year: 2022, month: 1, day: 1))

                expectation.fulfill()
            }
        }
    }

    func test_deleteProject_案件情報を削除できること() throws {
        // arrange
        dataInsert(
            projects: [
                ProjectDataObjectBuilder()
                    .content("content1")
                    .identifier("identifier1")
                    .title("title1")
                    .build(),
                ProjectDataObjectBuilder()
                    .content("content2")
                    .identifier("identifier2")
                    .title("title2")
                    .build(),
                ProjectDataObjectBuilder()
                    .content("content3")
                    .identifier("identifier3")
                    .title("title3")
                    .build()
            ]
        )

        // act
        let publisher = model.deleteProject(
            ProfileModelObjectBuilder()
                .build(),
            identifier: "identifier2"
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!
                let projects = profile.projects?.allObjects as! [Project]

                // assert
                XCTAssertFalse(projects.contains(where: { $0.title == "title2" }))
                XCTAssertFalse(projects.contains(where: { $0.content == "content2" }))

                expectation.fulfill()
            }
        }
    }

    func test_deleteAllProject_案件情報を全件削除できること() throws {
        // arrange
        dataInsert(
            projects: [
                ProjectDataObjectBuilder()
                    .content("content")
                    .identifier("identifier")
                    .title("title")
                    .build()
            ]
        )

        // act
        let publisher = model.deleteAllProject(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!

                // assert
                XCTAssertTrue(profile.projects.isEmtpy)

                expectation.fulfill()
            }
        }
    }

    func test_updateIconImage_iconImageを更新できること() throws {
        // arrange
        dataInsert()

        // act
        let publisher = model.updateIconImage(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .iconImage(Asset.penguin.image.pngData())
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let profile = self.storage.allObjects.first!

                // assert
                XCTAssertEqual(
                    profile.iconImage,
                    Asset.penguin.image.pngData()
                )

                expectation.fulfill()
            }
        }
    }

    func test_updateProfileIcon_有効値の場合にuserDefaultsを更新できること() {
        // arrange
        model.updateProfileIcon(index: 0)

        // assert
        XCTAssertEqual(
            DataHolder.profileIcon,
            .elephant
        )
    }

    func test_updateProfileIcon_不正値の場合にデフォルト値でuserDefaultsを更新できること() {
        // arrange
        model.updateProfileIcon(index: 100)

        // assert
        XCTAssertEqual(
            DataHolder.profileIcon,
            .penguin
        )
    }

    func test_updateProfileProjectSortType_userDefaultsを更新できること() {
        // arrange
        model.updateProfileProjectSortType(.ascending)

        // assert
        XCTAssertEqual(
            DataHolder.profileProjectSortType,
            .ascending
        )
    }

    func test_delete_プロフィール情報を削除できること() {
        // arrange
        dataInsert()

        // act
        model.delete(
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .build()
        )

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let allProfile = self.storage.allObjects

                // assert
                XCTAssertTrue(allProfile.isEmpty)

                expectation.fulfill()
            }
        }
    }
}

private extension ProfileModelTest {
    func dataInsert(
        skill: Skill? = nil,
        projects: [Project] = []
    ) {
        storage.create().sink {
            $0.object.address = "テスト県テスト市テスト1-1-1"
            $0.object.birthday = Calendar.date(year: 2000, month: 1, day: 1)
            $0.object.email = "test@test.com"
            $0.object.gender = .man
            $0.object.iconImage = Asset.penguin.image.pngData()
            $0.object.identifier = "identifier"
            $0.object.name = "testName"
            $0.object.phoneNumber = "08011112222"
            $0.object.station = "鶴橋駅"

            if let skill {
                $0.object.skill = skill
            }

            if !projects.isEmpty {
                $0.object.projects = .init(array: projects)
            }

            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
