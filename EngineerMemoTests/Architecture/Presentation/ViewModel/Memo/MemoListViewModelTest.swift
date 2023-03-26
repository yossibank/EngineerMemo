import Combine
@testable import EngineerMemo
import XCTest

final class MemoListViewModelTest: XCTestCase {
    private var model: MemoModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoListViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        analytics = .init(screenId: .memoList)
        viewModel = .init(
            model: model,
            analytics: analytics
        )

        model.getsHandler = {
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
}
