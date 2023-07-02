@testable import EngineerMemo
import XCTest

final class ModelsTest: XCTestCase {
    private var memoModel: MemoModel!
    private var profileModel: ProfileModel!
    private var settingModel: SettingModel!

    override func setUp() {
        super.setUp()

        memoModel = Models.Memo()
        profileModel = Models.Profile()
        settingModel = Models.Setting()
    }

    override func tearDown() {
        super.tearDown()

        memoModel = nil
        profileModel = nil
        settingModel = nil
    }

    func test_MemoModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(memoModel)
    }

    func test_ProfileModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(profileModel)
    }

    func test_SettingModelのModelを生成できること() {
        // assert
        XCTAssertNotNil(settingModel)
    }
}
