@testable import EngineerMemo
import XCTest

final class AppErrorConverterTest: XCTestCase {
    private var converter: AppErrorConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

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
        XCTAssertEqual(actual.errorType, .something(actual.errorDescription))
        XCTAssertEqual(actual.errorDescription, "デコードエラーです")
    }

    func test_emptyDataのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.emptyData)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .something(actual.errorDescription))
        XCTAssertEqual(actual.errorDescription, "空のデータです")
    }

    func test_emptyResponseのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.emptyResponse)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .something(actual.errorDescription))
        XCTAssertEqual(actual.errorDescription, "空のレスポンスです")
    }

    func test_invalidRequestのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.api(.invalidRequest)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .something(actual.errorDescription))
        XCTAssertEqual(actual.errorDescription, "無効なリクエストです")
    }

    func test_timeoutErrorのAPIErrorをAppErrorのエラー種別timeoutで受け取れること() {
        // arrange
        let input = DataError.api(.timeoutError)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .timeout)
        XCTAssertEqual(actual.errorDescription, "タイムアウトエラーです")
    }

    func test_urlSessionErrorのAPIErrorをAppErrorのエラー種別urlSessionで受け取れること() {
        // arrange
        let input = DataError.api(.urlSessionError)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .urlSession)
        XCTAssertEqual(actual.errorDescription, "URLSessionエラーです")
    }

    func test_invalidStatusCodeのAPIErrorをAppErrorのエラー種別invalidStatusCodeで受け取れること() {
        // arrange
        let input = DataError.api(.invalidStatusCode(400))

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .invalidStatusCode(400))
        XCTAssertEqual(actual.errorDescription, "無効なステータスコード【400】です")
    }

    func test_unknownのAPIErrorをAppErrorのエラー種別unknownで受け取れること() {
        // arrange
        let input = DataError.api(.unknown)

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .unknown)
        XCTAssertEqual(actual.errorDescription, "不明なエラーです")
    }

    func test_somethingのCoreDataErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = DataError.coreData(.something("CoreDataのエラー"))

        // assert
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(actual.errorType, .something("CoreDataのエラー"))
        XCTAssertEqual(actual.errorDescription, "CoreDataのエラー")
    }
}
