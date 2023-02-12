import Combine
@testable import EngineerMemo
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: 対象ViewModel!

    override func setUp() {
        super.setUp()

        analytics = .init(screenId: 対象スクリーンID)
        viewModel = .init(analytics: analytics)
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        analytics.logEventFAEventHandler = {
            // assert
            XCTassertEqual(
                $0,
                .screenView
            )

            expectation.fulfill()
        }

        // act
        viewModel.input.viewWillAppear.send(())

        wait(for: [expectation], timeout: 0.1)
    }
}

private extension ___FILEBASENAME___ {
    // ViewModel生成時にAPIを叩くなどの成功・失敗のハンドリングが必要な場合
    // setUp()内に処理を割り当てられないため、各テストケース内で初期化処理を行う
    // func setupViewModel(isSuccess: Bool = true)のような初期設定関数を作成する
}
