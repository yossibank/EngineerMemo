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

    func test_DataHolder_sample_デフォルト値にsample1が保存されていること() {
        // assert
        XCTAssertEqual(DataHolder.sample, .sample1)
    }

    func test_DataHolder_sample_正しい値が保存されていること() {
        // act
        DataHolder.sample = .sample1

        // assert
        XCTAssertEqual(DataHolder.sample, .sample1)

        // act
        DataHolder.sample = .sample2

        // assert
        XCTAssertEqual(DataHolder.sample, .sample2)

        // act
        DataHolder.sample = .sample3

        // assert
        XCTAssertEqual(DataHolder.sample, .sample3)
    }

    func test_DataHolder_sample_publisherで値を受け取れること() throws {
        // arrange
        let samplePublisher = DataHolder.$sample.collect(1).first()

        DataHolder.sample = .sample3

        // act
        let output = try awaitOutputPublisher(samplePublisher)

        // assert
        XCTAssertEqual(output.first, .sample3)
    }
}
