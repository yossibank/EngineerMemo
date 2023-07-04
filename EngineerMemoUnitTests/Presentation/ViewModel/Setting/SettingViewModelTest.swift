import Combine
@testable import EngineerMemo
import XCTest

final class SettingViewModelTest: XCTestCase {
    private var model: SettingModelInputMock!
    private var routing: SettingRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SettingViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .setting)
        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .screenView
            )
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_input_didChangeColorThemeIndex_modelにindex値を送信できること() {
        // arrange
        model.updateColorThemeHandler = {
            // assert
            XCTAssertEqual(
                $0,
                2
            )
        }

        // act
        viewModel.input.didChangeColorThemeIndex.send(2)
    }

    func test_input_didTapReviewCell_output_didTapReviewがtrueを出力すること() {
        // act
        viewModel.input.didTapReviewCell.send(())

        // assert
        XCTAssertTrue(viewModel.output.didTapReview)
    }

    func test_input_didTapLicenceCell_routing_showLicenceScreenが呼ばれること() {
        // arrange
        routing.showLicenceScreenHandler = {}

        // act
        viewModel.input.didTapLicenceCell.send(())

        // assert
        XCTAssertEqual(
            routing.showLicenceScreenCallCount,
            1
        )
    }
}
