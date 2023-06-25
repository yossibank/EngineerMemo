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

    func test_binding_category_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.category = .interview

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.category,
                .interview
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_title_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.title = "title"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.title,
                "title"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_content_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.content = "content"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.content,
                "content"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_bindingの値が有効時_output_isEnabledがtrueを取得できること() throws {
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

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel(modelObject: nil)

        model.createHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }

    func test_input_didTapBarButton_setting_メモ作成処理がよばれること() {
        // arrange
        setupViewModel(modelObject: nil)

        model.createHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_update_メモ更新処理が呼ばれること() {
        // arrange
        setupViewModel(modelObject: MemoModelObjectBuilder().build())

        model.updateHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }
}

private extension MemoUpdateViewModelTest {
    func setupViewModel(modelObject: MemoModelObject?) {
        model = .init()

        analytics = modelObject.isNil
            ? .init(screenId: .memoCreate)
            : .init(screenId: .memoUpdate)

        viewModel = .init(
            model: model,
            modelObject: modelObject,
            analytics: analytics
        )

        viewModel.input.viewDidLoad.send(())
    }
}
