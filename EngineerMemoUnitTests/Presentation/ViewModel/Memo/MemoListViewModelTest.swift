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

    override func tearDown() {
        super.tearDown()

        model = nil
        routing = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewDidLoad_メモ情報を取得できること() throws {
        // arrange
        viewDidLoad(modelObjects: [MemoModelObjectBuilder().build()])

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertFalse(output.isMemoEmpty)
        XCTAssertFalse(output.isResultEmpty)
        XCTAssertEqual(output.outputObjects, [MemoModelObjectBuilder().build()])
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

    func test_input_didTapUpdateButton_routing_showUpdateScreenが呼び出されること() {
        // act
        viewModel.input.didTapUpdateButton.send(())

        // assert
        XCTAssertEqual(
            routing.showUpdateScreenCallCount,
            1
        )
    }

    func test_input_didChangeSort_並び替えたメモ情報を取得できること() throws {
        // arrange
        viewDidLoad(modelObjects: (1 ... 6).map {
            MemoModelObjectBuilder()
                .title("title\($0)")
                .createdAt(Calendar.date(year: 2000, month: 1, day: $0)!)
                .build()
        })

        // act
        viewModel.input.didChangeCategory.send(.all)
        viewModel.input.didChangeSort.send(.descending)

        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertFalse(output.isMemoEmpty)
        XCTAssertFalse(output.isResultEmpty)
        XCTAssertEqual(output.outputObjects[0].title, "title6")
        XCTAssertEqual(output.outputObjects[1].title, "title5")
        XCTAssertEqual(output.outputObjects[2].title, "title4")
        XCTAssertEqual(output.outputObjects[3].title, "title3")
        XCTAssertEqual(output.outputObjects[4].title, "title2")
        XCTAssertEqual(output.outputObjects[5].title, "title1")
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
        XCTAssertFalse(output.isMemoEmpty)
        XCTAssertFalse(output.isResultEmpty)
        XCTAssertEqual(output.outputObjects.count, 2)
    }

    func test_input_didSelectContent_ログイベントが送信されていること() {
        // arrange
        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .didTapMemoList(title: "title")
            )
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
            XCTAssertEqual(
                $0,
                "identifier"
            )
        }

        // act
        viewModel.input.didSelectContent.send(MemoModelObjectBuilder().build())
    }

    func test_output_modelObject_メモ情報が空の際にisMemoEmptyがtrueを出力すること() throws {
        // arrange
        viewDidLoad(modelObjects: [])

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertTrue(output.isMemoEmpty)
        XCTAssertTrue(output.isResultEmpty)
        XCTAssertTrue(output.outputObjects.isEmpty)
    }

    func test_output_modelObject_絞り込んだメモ情報が空の際にisResultEmptyがtrueを出力すること() throws {
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
        viewModel.input.didChangeCategory.send(.event)

        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!!

        // assert
        XCTAssertFalse(output.isMemoEmpty)
        XCTAssertTrue(output.isResultEmpty)
        XCTAssertTrue(output.outputObjects.isEmpty)
    }
}

private extension MemoListViewModelTest {
    func viewDidLoad(modelObjects: [MemoModelObject]) {
        model.fetchHandler = {
            Deferred {
                Future<[MemoModelObject], AppError> { promise in
                    promise(.success(modelObjects))
                }
            }
            .eraseToAnyPublisher()
        }

        viewModel.input.viewDidLoad.send(())
    }
}
