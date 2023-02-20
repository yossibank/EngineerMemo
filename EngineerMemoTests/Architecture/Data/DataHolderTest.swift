@testable import EngineerMemo
import XCTest

final class DataHolderTest: XCTestCase {
    override func setUp() {
        super.setUp()

        resetUserDefaults()
    }

    override func tearDown() {
        super.tearDown()

        resetUserDefaults()
    }

    func test_dataHolder_publisherで値を受け取れること() throws {
        // arrange
        let samplePublisher = DataHolder.$sample.collect(1).first()

        DataHolder.sample = .sample3

        // act
        let output = try awaitOutputPublisher(samplePublisher)

        // assert
        XCTAssertEqual(output.first, .sample3)
    }
}
