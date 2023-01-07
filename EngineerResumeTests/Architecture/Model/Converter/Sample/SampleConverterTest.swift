@testable import EngineerResume
import XCTest

final class SampleConverterTest: XCTestCase {
    private var converter: SampleConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    func test_SampleDataObjectをSampleModelObjectに変換できること() {
        // arrange
        let input = SampleDataObjectBuilder()
            .userId(1)
            .id(1)
            .title("title")
            .body("body")
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            SampleModelObjectBuilder()
                .userId(1)
                .id(1)
                .title("title")
                .body("body")
                .build()
        )
    }

    func test_SampleDataOjbectの配列をSampleModelObjectの配列に変換できること() {
        // arrange
        let input = [
            SampleDataObjectBuilder()
                .userId(1)
                .id(1)
                .title("title")
                .body("body")
                .build()
        ]

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            [
                SampleModelObjectBuilder()
                    .userId(1)
                    .id(1)
                    .title("title")
                    .body("body")
                    .build()
            ]
        )
    }
}
