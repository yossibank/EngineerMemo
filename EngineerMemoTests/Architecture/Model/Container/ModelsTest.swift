@testable import EngineerMemo
import XCTest

final class ModelsTest: XCTestCase {
    private var sampleModel: SampleModel!
    private var profileModel: ProfileModel!

    override func setUp() {
        super.setUp()

        sampleModel = Models.Sample()
        profileModel = Models.Profile()
    }

    func test_SampleModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(sampleModel)
    }

    func test_ProfileModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(profileModel)
    }
}
