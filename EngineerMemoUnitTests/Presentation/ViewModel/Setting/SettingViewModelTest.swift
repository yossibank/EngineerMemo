import Combine
@testable import EngineerMemo
import XCTest

final class SettingViewModelTest: XCTestCase {
    private var model: SettingModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SettingViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        analytics = .init(screenId: .setting)
        viewModel = .init(
            model: model,
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
}
