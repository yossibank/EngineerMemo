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
        let publisher = DataHolder.$colorTheme.collect(1).first()

        DataHolder.colorTheme = .dark

        // act
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(output, .dark)
    }
}
