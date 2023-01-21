@testable import EngineerMemo
import XCTest

final class SampleDetailViewModelTest: XCTestCase {
    private var routing: SampleDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SampleDetailViewModel!

    override func setUp() {
        super.setUp()

        routing = .init()
        analytics = .init(screenId: .sampleDetail)
        viewModel = .init(
            modelObject: SampleModelObjectBuilder().build(),
            routing: routing,
            analytics: analytics
        )
    }

    func test_viewWillAppear_firebaseAnalytics_screenViewイベントを送信できていること() {
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

    func test_barButtonTapped_routing_showEditScreenが呼び出されること() {
        // act
        viewModel.input.barButtonTapped.send(())

        // assert
        XCTAssertEqual(routing.showEditScreenCallCount, 1)
    }
}
