@testable import EngineerResume
import XCTest

final class DataErrorConverterTest: XCTestCase {
    private var converter: AppErrorConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    func test_DataErrorをAppErrorに変換できること() {
        // arrange
        let input = DataError.api(.invalidRequest)

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            .init(dataError: .api(.invalidRequest))
        )
    }

    func test_decodeErrorのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.decodeError)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_emptyDataのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.emptyData)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_emptyResponseのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.emptyResponse)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_invalidRequestのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.emptyResponse)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_urlSessionErrorのAPIErrorをAppErrorのエラー種別urlSessionで受け取れること() {
        // arrange
        let input = DataError.api(.urlSessionError)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .urlSession
        )
    }

    func test_invalidStatusCodeのAPIErrorをAppErrorのエラー種別invalidStatusCodeで受け取れること() {
        // arrange
        let input = DataError.api(.invalidStatusCode(400))

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .invalidStatusCode(400)
        )
    }

    func test_unknownのAPIErrorをAppErrorのエラー種別unknownで受け取れること() {
        // arrange
        let input = DataError.api(.unknown)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .unknown
        )
    }

    func test_somethingのCoreDataErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.coreData(.something("CoreDataのエラー"))

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something("CoreDataのエラー")
        )
    }
}
