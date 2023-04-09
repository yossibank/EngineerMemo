import Combine
@testable import EngineerMemo
import XCTest

final class MemoDetailViewModelTest: XCTestCase {
    private var modelObject: MemoModelObject!
    private var routing: MemoDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: MemoDetailViewModel!

    override func setUp() {
        super.setUp()

        modelObject = MemoModelObjectBuilder().build()
        routing = .init()
        analytics = .init(screenId: .memoDetail)
        viewModel = .init(
            modelObject: modelObject,
            routing: routing,
            analytics: analytics
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

    func test_input_didTapBarButton_routing_showUpdateScreenが呼び出されること() {
        // arrange
        routing.showUpdateScreenHandler = {
            // assert
            XCTAssertEqual($0, MemoModelObjectBuilder().build())
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }
}
