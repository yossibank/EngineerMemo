import Combine
@testable import EngineerResume
import XCTest

final class SampleEditViewModelTest: XCTestCase {
    private var model: SampleModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SampleEditViewModel!

    func test_受け取ったModelObjectがBindingに入力されていること() {
        // arrange
        setupViewModel()

        // assert
        XCTAssertEqual(
            viewModel.binding.title,
            "sample title"
        )

        XCTAssertEqual(
            viewModel.binding.body,
            "sample body"
        )
    }

    func test_viewWillAppear_FirebaseAnalytics_screenViewイベントを送信できていること() {
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

    func test_title_bodyのどちらかが空文字の場合_output_isEnabledがfalseを出力すること() {
        // arrange
        setupViewModel()

        // act
        viewModel.binding.title = ""
        viewModel.binding.body = String(repeating: "b", count: 15)

        // assert
        XCTAssertFalse(viewModel.output.isEnabled!)
    }

    func test_title_bodyが共に空文字でない場合_output_isEnabledがtrueを出力すること() {
        // arrange
        setupViewModel()

        // act
        viewModel.binding.title = String(repeating: "a", count: 15)
        viewModel.binding.body = String(repeating: "b", count: 15)

        // assert
        XCTAssertTrue(viewModel.output.isEnabled!)
    }

    func test_成功_編集ボタンをタップした際に入力情報を更新できること() throws {
        // arrange
        setupViewModel()

        // act
        viewModel.input.editButtonTapped.send(())

        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            SampleModelObjectBuilder()
                .title("sample edit title")
                .body("sample edit body")
                .build()
        )
    }

    func test_失敗_編集ボタンをタップした際にエラー情報を取得できること() throws {
        // arrange
        setupViewModel(isSuccess: false)

        // act
        viewModel.input.editButtonTapped.send(())

        let publisher = viewModel.output.$appError.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            .init(dataError: .api(.invalidStatusCode(400)))
        )
    }
}

private extension SampleEditViewModelTest {
    func setupViewModel(isSuccess: Bool = true) {
        model = .init()
        analytics = .init(screenId: .sampleEdit)

        if isSuccess {
            model.putHandler = { _, _ in
                Future<SampleModelObject, AppError> { promise in
                    promise(
                        .success(
                            SampleModelObjectBuilder()
                                .title("sample edit title")
                                .body("sample edit body")
                                .build()
                        )
                    )
                }
                .eraseToAnyPublisher()
            }
        } else {
            model.putHandler = { _, _ in
                Future<SampleModelObject, AppError> { promise in
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
            modelObject: SampleModelObjectBuilder().build(),
            analytics: analytics
        )
    }
}
