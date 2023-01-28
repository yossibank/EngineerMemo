import Combine
@testable import EngineerMemo
import XCTest

final class ProfileUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileUpdateViewModel!

    func test_viewWillAppear_設定_firebaseAnalytics_screenViewイベントを送信できていること() {
        // arrange
        setupViewModel(type: .setting)

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

    func test_saveButtonTapped_output_isFinishがtrueを取得できること() {
        // arrange
        setupViewModel(type: .setting)

        // act
        viewModel.input.saveButtonTapped.send(())

        // arrange
        XCTAssertTrue(viewModel.output.isFinish!)
    }
}

private extension ProfileUpdateViewModelTest {
    func setupViewModel(type: ProfileUpdateType) {
        model = .init()
        analytics = .init(screenId: type.screenId)
        viewModel = .init(
            model: model,
            analytics: analytics
        )
    }
}
