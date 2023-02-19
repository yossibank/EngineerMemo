import Combine
@testable import EngineerMemo
import XCTest

final class ProfileDetailViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var routing: ProfileDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileDetailViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .profileDetail)
        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.getHandler = { result in
            result(.success(ProfileModelObjectBuilder().build()))
        }
    }

    func test_画面表示_成功_プロフィール情報を取得できること() throws {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            ProfileModelObjectBuilder().build()
        )
    }

    func test_画面表示_失敗_エラー情報を取得できること() throws {
        // arrange
        model.getHandler = { result in
            result(.failure(.init(dataError: .coreData(.something("CoreDataエラー")))))
        }

        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$appError.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            .init(dataError: .coreData(.something("CoreDataエラー")))
        )
    }

    func test_viewWillAppear_firebaseAnalytics_screenViewイベントを送信できること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        analytics.sendEventFAEventHandler = { event in
            // assert
            XCTAssertEqual(event, .screenView)
            expectation.fulfill()
        }

        // act
        viewModel.input.viewWillAppear.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_settingButtonTapped_routing_showUpdateScreenが呼び出されること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        routing.showUpdateScreenHandler = { type in
            XCTAssertEqual(type, .setting)

            expectation.fulfill()
        }

        // act
        viewModel.input.settingButtonTapped.send(())

        // assert
        XCTAssertEqual(routing.showUpdateScreenCallCount, 1)
    }

    func test_editButtonTapped_routing_showUpdateScreenが呼び出されること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showUpdateScreenHandler = { type in
            XCTAssertEqual(type, .update(modelObject))

            expectation.fulfill()
        }

        // act
        viewModel.input.editButtonTapped.send(modelObject)

        // assert
        XCTAssertEqual(routing.showUpdateScreenCallCount, 1)
    }
}
