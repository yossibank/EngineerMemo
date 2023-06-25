import Combine
@testable import EngineerMemo
import XCTest

final class MemoDetailViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var routing: MemoDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoDetailViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .memoDetail)
        viewModel = .init(
            identifier: "identifier",
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.findHandler = { _ in
            Deferred {
                Future<MemoModelObject, AppError> { promise in
                    promise(.success(MemoModelObjectBuilder().build()))
                }
            }
            .eraseToAnyPublisher()
        }

        viewModel.input.viewDidLoad.send(())
    }

    override func tearDown() {
        super.tearDown()

        model = nil
        routing = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewDidLoad_メモ情報を取得できること() throws {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            MemoModelObjectBuilder().build()
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

    func test_input_didTapEditBarButton_routing_showUpdateScreenが呼び出されること() {
        // arrange
        routing.showUpdateScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                MemoModelObjectBuilder().build()
            )
        }

        // act
        viewModel.input.didTapEditBarButton.send(())
    }

    func test_input_didTapDeleteBarButton_output_isDeletedがtrueを取得できること() throws {
        // arrange
        model.deleteHandler = {
            // assert
            XCTAssertEqual(
                $0,
                MemoModelObjectBuilder().build()
            )
        }

        // act
        viewModel.input.didTapDeleteBarButton.send(())

        let publisher = viewModel.output.$isDeleted.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertTrue(output)
    }
}
