@testable import EngineerMemo
import XCTest

final class ModelsTest: XCTestCase {
    private var memoModel: MemoModel!
    private var profileModel: ProfileModel!

    override func setUp() {
        super.setUp()

        memoModel = Models.Memo()
        profileModel = Models.Profile()
    }

    override func tearDown() {
        super.tearDown()

        memoModel = nil
        profileModel = nil
    }

    func test_MemoModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(memoModel)
    }

    func test_ProfileModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(profileModel)
    }
}
