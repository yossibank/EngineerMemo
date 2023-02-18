@testable import EngineerMemo
import XCTest

final class ModelsTest: XCTestCase {
    private var profileModel: ProfileModel!

    override func setUp() {
        super.setUp()

        profileModel = Models.Profile()
    }

    func test_ProfileModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(profileModel)
    }
}
