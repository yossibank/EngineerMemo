import Combine
@testable import EngineerResume
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
            XCTAssertEqual(value.age, 20)
            XCTAssertEqual(value.email, "test@test.com")
            XCTAssertEqual(value.genderEnum, .man)
            XCTAssertEqual(value.identifier, "identifier")
            XCTAssertEqual(value.name, "testName")
            XCTAssertEqual(value.phoneNumber, 11_123_456_789)
            XCTAssertEqual(value.station, "鶴橋駅")

            expectation.fulfill()

            return ProfileModelObjectBuilder()
                .address(value.address!)
                .age(value.age!.intValue)
                .email(value.email!)
                .gender(.init(rawValue: value.genderEnum!.rawValue)!)
                .name(value.name!)
                .phoneNumber(value.phoneNumber!.intValue)
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
                        .age(20)
                        .email("test@test.com")
                        .gender(.man)
                        .identifier("identifier")
                        .name("testName")
                        .phoneNumber(11_123_456_789)
                        .station("鶴橋駅")
                        .build()
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
                .age(10)
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let profile = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(profile.name, "テスト")
            XCTAssertEqual(profile.age, 10)

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
                .age(100)
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let profile = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(profile.name, "テスト更新後")
            XCTAssertEqual(profile.age, 100)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }
}

private extension ProfileModelTest {
    func dataInsert() {
        storage.create()
            .sink { profile in
                profile.address = "テスト県テスト市テスト1-1-1"
                profile.age = 20
                profile.email = "test@test.com"
                profile.genderEnum = .man
                profile.identifier = "identifier"
                profile.name = "testName"
                profile.phoneNumber = 11_123_456_789
                profile.station = "鶴橋駅"
            }
            .store(in: &cancellables)
    }
}
