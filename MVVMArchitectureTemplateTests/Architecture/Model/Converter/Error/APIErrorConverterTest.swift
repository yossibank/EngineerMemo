@testable import MVVMArchitectureTemplate
import XCTest

final class APIErrorConverterTest: XCTestCase {
    func test_APIErrorをAppErrorに変換できること() {
        // arrange
        let input = APIError.invalidRequest

        // act
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual,
            .init(error: .invalidRequest)
        )
    }

    func test_decodeErrorのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = APIError.decodeError

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_emptyDataのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = APIError.emptyData

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_emptyResponseのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = APIError.emptyResponse

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_invalidRequestのAPIErrorをAppErrorのエラー種別somethingで受け取れること() {
        // arrange
        let input = APIError.emptyResponse

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .something(actual.errorDescription)
        )
    }

    func test_urlSessionErrorのAPIErrorをAppErrorのエラー種別urlSessionで受け取れること() {
        // arrange
        let input = APIError.urlSessionError

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .urlSession
        )
    }

    func test_invalidStatusCodeのAPIErrorをAppErrorのエラー種別invalidStatusCodeで受け取れること() {
        // arrange
        let input = APIError.invalidStatusCode(400)

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .invalidStatusCode(400)
        )
    }

    func test_unknownのAPIErrorをAppErrorのエラー種別unknownで受け取れること() {
        // arrange
        let input = APIError.unknown

        // assert
        let actual = AppErrorConverter().convert(input)

        // assert
        XCTAssertEqual(
            actual.errorType,
            .unknown
        )
    }
}
