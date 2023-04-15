import Combine
@testable import EngineerMemo
import XCTest

final class MemoListViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var routing: MemoListRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoListViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .memoList)
        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.fetchHandler = {
            $0(.success([MemoModelObjectBuilder().build()]))
        }
    }

    func test_input_viewDidLoad_メモ情報を取得できること() throws {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$modelObjects.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            [MemoModelObjectBuilder().build()]
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

    func test_input_didTapCreateButton_routing_showCreateScreenが呼び出されること() {
        // act
        viewModel.input.didTapCreateButton.send(())

        // assert
        XCTAssertEqual(routing.showCreateScreenCallCount, 1)
    }

    func test_input_didSelectContent_ログイベントが送信されていること() {
        // arrange
        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual($0, .didTapMemoList(title: "title"))
        }

        // act
        viewModel.input.didSelectContent.send(
            MemoModelObjectBuilder()
                .title("title")
                .build()
        )
    }

    func test_input_didSelectContent_routing_showDetailScreenが呼び出されること() {
        // arrange
        routing.showDetailScreenHandler = {
            // assert
            XCTAssertEqual($0, "identifier")
        }

        // act
        viewModel.input.didSelectContent.send(MemoModelObjectBuilder().build())
    }
}
