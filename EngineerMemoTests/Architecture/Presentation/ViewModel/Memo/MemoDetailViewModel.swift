import Combine
@testable import EngineerMemo
import XCTest

final class MemoDetailViewModelTest: XCTestCase {
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoDetailViewModel!

    override func setUp() {
        super.setUp()

        analytics = .init(screenId: .memoDetail)
        viewModel = .init(analytics: analytics)
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
