import Combine
@testable import EngineerMemo
import XCTest

final class MemoUpdateViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoUpdateViewModel!

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel(modelObject: nil)

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

    func test_binding_category_作成ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.category = .interview

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.category,
                .interview
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_title_作成ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.title = "title"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.title,
                "title"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_content_作成ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.content = "content"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.content,
                "content"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_各binding値代入時にoutput_isEnabledがtrueを取得できること() throws {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.title = "title"
        viewModel.binding.content = "content"

        // act
        let publisher = viewModel.output.$isEnabled.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertTrue(output)
    }

    func test_input_didTapBarButton_modelObjectがnilの際に作成側の関数が呼ばれること() {
        // arrange
        setupViewModel(modelObject: nil)

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(
            model.createCallCount,
            1
        )
    }

    func test_input_didTapBarButton_modelObjectに値がある際に作成側の関数が呼ばれること() {
        // arrange
        setupViewModel(modelObject: MemoModelObjectBuilder().build())

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(
            model.updateCallCount,
            1
        )
    }

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel(modelObject: nil)

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }
}

private extension MemoUpdateViewModelTest {
    func setupViewModel(modelObject: MemoModelObject?) {
        model = .init()
        analytics = .init(screenId: .memoCreate)
        viewModel = .init(
            model: model,
            modelObject: modelObject,
            analytics: analytics
        )

        viewModel.input.viewDidLoad.send(())
    }
}
