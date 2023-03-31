import Combine
@testable import EngineerMemo
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var model: 対象ModelMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: 対象ViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        analytics = .init(screenId: 対象スクリーンID)
        viewModel = .init(
            model: model,
            analytics: analytics
        )
    }

    func test_input_viewDidLoad_初期化時処理が実行されること() {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act

        // assert
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
