import Combine
@testable import EngineerMemo
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var apiClient: APIClientInputMock!
    private var 対象Converter: 対象ConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: 対象Model!

    override func setUp() {
        super.setUp()

        apiClient = .init()
        対象Converter = .init()
        errorConverter = .init()
        model = .init()
    }

    override func tearDown() {
        super.tearDown()

        // CoreData操作必要な場合はデータリセット
        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_情報を取得できること() throws {
        // arrange
        apiClient.requestHandler = { request, completion in
            // assert
            XCTAssertEqual(request is 対象リクエスト)

            if let completion = completion as? (Result<対象DataObject, APIError>) -> Void {
                completion(.success(対象DataObjectBuilder().build()))
            }
        }

        対象Converter.convertHandler = { _ in
            対象ModelObjectBuilder().build()
        }

        // act
        let publisher = model.対象メソッド()
        let value = try awaitValuePublisher(publisher)

        // assert
        XCTAssertEqual(
            value,
            対象ModelObjectBuilder().build()
        )
    }
}