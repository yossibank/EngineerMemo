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
    }

    func test_input_viewDidLoad_メモ情報を取得できること() throws {
        // arrange
        viewDidLoad()

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertEqual(
            output.output,
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

    func test_input_didChangeSort_並び替えたメモ情報を取得できること() throws {
        // arrange
        viewDidLoad(modelObjects: [
            MemoModelObjectBuilder().title("title1").createdAt(Calendar.date(year: 2000, month: 1, day: 1)!).build(),
            MemoModelObjectBuilder().title("title2").createdAt(Calendar.date(year: 2000, month: 1, day: 2)!).build(),
            MemoModelObjectBuilder().title("title3").createdAt(Calendar.date(year: 2000, month: 1, day: 3)!).build(),
            MemoModelObjectBuilder().title("title4").createdAt(Calendar.date(year: 2000, month: 1, day: 4)!).build(),
            MemoModelObjectBuilder().title("title5").createdAt(Calendar.date(year: 2000, month: 1, day: 5)!).build(),
            MemoModelObjectBuilder().title("title6").createdAt(Calendar.date(year: 2000, month: 1, day: 6)!).build()
        ])

        // act
        viewModel.input.didChangeCategory.send(.all)
        viewModel.input.didChangeSort.send(.descending)

        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertEqual(output.output[0].title, "title6")
        XCTAssertEqual(output.output[1].title, "title5")
        XCTAssertEqual(output.output[2].title, "title4")
        XCTAssertEqual(output.output[3].title, "title3")
        XCTAssertEqual(output.output[4].title, "title2")
        XCTAssertEqual(output.output[5].title, "title1")
    }

    func test_input_didChangeCategory_絞り込んだメモ情報を取得できること() throws {
        // arrange
        viewDidLoad(modelObjects: [
            MemoModelObjectBuilder().category(.todo).build(),
            MemoModelObjectBuilder().category(.technical).build(),
            MemoModelObjectBuilder().category(.interview).build(),
            MemoModelObjectBuilder().category(.other).build(),
            MemoModelObjectBuilder().category(.interview).build(),
            MemoModelObjectBuilder().category(.todo).build()
        ])

        // act
        viewModel.input.didChangeSort.send(.descending)
        viewModel.input.didChangeCategory.send(.todo)

        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertEqual(output.output.count, 2)
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

private extension MemoListViewModelTest {
    func viewDidLoad(modelObjects: [MemoModelObject] = [MemoModelObjectBuilder().build()]) {
        model.fetchHandler = {
            $0(.success(modelObjects))
        }

        viewModel.input.viewDidLoad.send(())
    }
}
