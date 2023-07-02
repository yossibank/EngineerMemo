import Combine
@testable import EngineerMemo
import XCTest

final class LicenceViewModelTest: XCTestCase {
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: LicenceViewModel!

    override func setUp() {
        super.setUp()

        analytics = .init(screenId: .licence)
        viewModel = .init(analytics: analytics)
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
}
