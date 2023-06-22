import Combine
@testable import EngineerMemo
import XCTest

final class MemoUpdateViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoUpdateViewModel!

    override func tearDown() {
        super.tearDown()

        model = nil
        analytics = nil
        viewModel = nil
    }

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

        model.updateHandler = { modelObject, _ in
            // assert
            XCTAssertEqual(
                modelObject.category,
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

        model.updateHandler = { modelObject, _ in
            // assert
            XCTAssertEqual(
                modelObject.title,
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

        model.updateHandler = { modelObject, _ in
            // assert
            XCTAssertEqual(
                modelObject.content,
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

    func test_input_didTapBarButton_setting_メモ作成処理がよばれること() {
        // arrange
        setupViewModel(modelObject: nil)

        model.updateHandler = { _, isNew in
            // assert
            XCTAssertTrue(isNew)
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_update_メモ更新処理が呼ばれること() {
        // arrange
        setupViewModel(modelObject: MemoModelObjectBuilder().build())

        model.updateHandler = { _, isNew in
            // assert
            XCTAssertFalse(isNew)
        }

        // act
        viewModel.input.didTapBarButton.send(())
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
