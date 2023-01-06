import Combine
@testable import EngineerResume
import XCTest

final class SampleListViewModelTest: XCTestCase {
    private var model: SampleModelInputMock!
    private var routing: SampleListRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SampleListViewModel!

    func test_画面表示_成功_一覧情報を取得できること() throws {
        // arrange
        setupViewModel()

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            [SampleModelObjectBuilder().build()]
        )
    }

    func test_画面表示_失敗_エラー情報を取得できること() throws {
        // arrange
        setupViewModel(isSuccess: false)

        // act
        let publisher = viewModel.output.$error.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            .init(dataError: .api(.invalidStatusCode(400)))
        )
    }

    func test_viewWillAppear_firebaseAnalytics_screenViewイベントを送信できていること() {
        // arrange
        setupViewModel()

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

    func test_barButtonTapped_routing_showAddScreenが呼び出されること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.barButtonTapped.send(())

        // assert
        XCTAssertEqual(routing.showAddScreenCallCount, 1)
    }

    func test_contentTapped_firebaseAnalytics_tapSampleListイベントを送信できていること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        analytics.sendEventFAEventHandler = { event in
            // assert
            XCTAssertEqual(event, .tapSmapleList(userId: 1))
            expectation.fulfill()
        }

        // act
        viewModel.input.contentTapped.send(.init(row: 0, section: 0))

        wait(for: [expectation], timeout: 0.1)
    }

    func test_contentTapped_routing_showDetailScreenが呼び出されること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.contentTapped.send((.init(row: 0, section: 0)))

        // assert
        XCTAssertEqual(routing.showDetailScreenCallCount, 1)
    }
}

private extension SampleListViewModelTest {
    func setupViewModel(isSuccess: Bool = true) {
        model = .init()
        routing = .init()
        analytics = .init(screenId: .sampleList)

        if isSuccess {
            model.getHandler = { _ in
                Future<[SampleModelObject], AppError> { promise in
                    promise(.success([SampleModelObjectBuilder().build()]))
                }
                .eraseToAnyPublisher()
            }
        } else {
            model.getHandler = { _ in
                Future<[SampleModelObject], AppError> { promise in
                    promise(
                        .failure(
                            .init(dataError: .api(.invalidStatusCode(400)))
                        )
                    )
                }
                .eraseToAnyPublisher()
            }
        }

        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )
    }
}
