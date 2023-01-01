@testable import EngineerResume
import XCTest

final class ModelsTest: XCTestCase {
    private var sampleModel: SampleModel!

    func test_SampleModelのModelを生成できること() {
        // arrange
        sampleModel = Models.Sample()

        // assert
        XCTAssertNotNil(sampleModel)
    }
}
