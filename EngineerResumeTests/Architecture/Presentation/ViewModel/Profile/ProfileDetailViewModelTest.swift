import Combine
@testable import EngineerResume
import XCTest

final class ProfileDetailViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileDetailViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        analytics = .init(screenId: .profileDetail)
        viewModel = .init(
            model: model,
            analytics: analytics
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
}
