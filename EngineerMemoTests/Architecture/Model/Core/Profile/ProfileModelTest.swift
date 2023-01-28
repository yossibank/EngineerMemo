import Combine
@testable import EngineerMemo
import XCTest

final class ProfileModelTest: XCTestCase {
    private var profileConverter: ProfileConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: ProfileModel!
    private var cancellables: Set<AnyCancellable> = .init()

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

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_get_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        profileConverter.convertHandler = { value in
            // assert
            XCTAssertEqual(value.address, "テスト県テスト市テスト1-1-1")
            XCTAssertEqual(value.birthday, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual(value.email, "test@test.com")
            XCTAssertEqual(value.genderEnum, .man)
            XCTAssertEqual(value.identifier, "identifier")
            XCTAssertEqual(value.name, "testName")
            XCTAssertEqual(value.phoneNumber, "08011112222")
            XCTAssertEqual(value.station, "鶴橋駅")

            expectation.fulfill()

            return ProfileModelObjectBuilder()
                .address(value.address!)
                .birthday(value.birthday!)
                .email(value.email!)
                .gender(.init(rawValue: value.genderEnum!.rawValue)!)
                .name(value.name!)
                .phoneNumber(value.phoneNumber!)
                .station(value.station!)
                .build()
        }

        // act
        model.get { result in
            switch result {
            case let .failure(appError):
                XCTFail(appError.localizedDescription)

            case let .success(modelObject):
                // assert
                XCTAssertEqual(
                    modelObject,
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

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_gets_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        profileConverter.convertHandler = { value in
            // assert
            XCTAssertEqual(value.address, "テスト県テスト市テスト1-1-1")
            XCTAssertEqual(value.birthday, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual(value.email, "test@test.com")
            XCTAssertEqual(value.genderEnum, .man)
            XCTAssertEqual(value.identifier, "identifier")
            XCTAssertEqual(value.name, "testName")
            XCTAssertEqual(value.phoneNumber, "08011112222")
            XCTAssertEqual(value.station, "鶴橋駅")

            expectation.fulfill()

            return ProfileModelObjectBuilder()
                .address(value.address!)
                .birthday(value.birthday!)
                .email(value.email!)
                .gender(.init(rawValue: value.genderEnum!.rawValue)!)
                .name(value.name!)
                .phoneNumber(value.phoneNumber!)
                .station(value.station!)
                .build()
        }

        // act
        model.gets { result in
            switch result {
            case let .failure(appError):
                XCTFail(appError.localizedDescription)

            case let .success(modelObject):
                // assert
                XCTAssertEqual(
                    modelObject,
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

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_create_情報を作成できること() {
        // act
        let expectation = XCTestExpectation(description: #function)

        model.create(
            modelObject: ProfileModelObjectBuilder()
                .name("テスト")
                .birthday(Calendar.date(year: 2000, month: 1, day: 1))
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let profile = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(profile.name, "テスト")
            XCTAssertEqual(profile.birthday, Calendar.date(year: 2000, month: 1, day: 1))

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }

    func test_update_情報を更新できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        // act
        model.update(
            modelObject: ProfileModelObjectBuilder()
                .identifier("identifier")
                .name("テスト更新後")
                .birthday(Calendar.date(year: 2000, month: 11, day: 1))
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let profile = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(profile.name, "テスト更新後")
            XCTAssertEqual(profile.birthday, Calendar.date(year: 2000, month: 11, day: 1))

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }

    func test_delete_情報を削除できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        // act
        model.delete(
            modelObject: ProfileModelObjectBuilder()
                .identifier("identifier")
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let allProfile = self.storage.allObjects

            // assert
            XCTAssertTrue(allProfile.isEmpty)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
}

private extension ProfileModelTest {
    func dataInsert() {
        storage.create()
            .sink { profile in
                profile.address = "テスト県テスト市テスト1-1-1"
                profile.birthday = Calendar.date(year: 2000, month: 1, day: 1)
                profile.email = "test@test.com"
                profile.genderEnum = .man
                profile.identifier = "identifier"
                profile.name = "testName"
                profile.phoneNumber = "08011112222"
                profile.station = "鶴橋駅"
            }
            .store(in: &cancellables)
    }
}