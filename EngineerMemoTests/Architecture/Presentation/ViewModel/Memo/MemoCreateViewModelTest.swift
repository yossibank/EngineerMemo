import Combine
@testable import EngineerMemo
import XCTest

final class MemoCreateViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoCreateViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        analytics = .init(screenId: .memoCreate)
        viewModel = .init(
            model: model,
            analytics: analytics
        )
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual($0, .screenView)
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_binding_title_作成ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        viewModel.binding.title = "title"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.title, "title")
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_content_作成ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        viewModel.binding.content = "content"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.content, "content")
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }
}
