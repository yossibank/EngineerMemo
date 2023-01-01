@testable import MVVMArchitectureTemplate
import XCTest

final class FAParameterTest: XCTestCase {
    func test_FAParameter_rawValueで適切な値が返却できていること() {
        XCTAssertEqual(FAParameter.screenId.rawValue, "スクリーンID")
        XCTAssertEqual(FAParameter.userId.rawValue, "ユーザーID")
    }
}
