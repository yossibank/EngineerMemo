@testable import EngineerResume
import XCTest

final class ProfileModelTest: XCTestCase {
    private var profileConverter: ProfileConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: ProfileModel!

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

    func test_get_成功_情報を取得できること() throws {
        // arrange
        CoreDataManager.shared.save(Profile.self) { profile in
            profile.name = "テスト"
            profile.age = 10
        }

        let expectation = XCTestExpectation(description: #function)

        profileConverter.convertHandler = { values in
            [
                ProfileModelObjectBuilder()
                    .name(values.first!.name!)
                    .age(values.first!.age!.intValue)
                    .build()
            ]
        }

        // act
        model.get { result in
            switch result {
            case let .failure(appError):
                XCTFail(appError.localizedDescription)

            case let .success(modelObject):
                // assert
                XCTAssertEqual(
                    modelObject.first,
                    ProfileModelObjectBuilder()
                        .name("テスト")
                        .age(10)
                        .build()
                )
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
