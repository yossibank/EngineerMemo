@testable import EngineerMemo
import iOSSnapshotTestCase
import OHHTTPStubs
import OHHTTPStubsSwift

final class ___FILEBASENAME___: FBSnapshotTestCase {
    private var subject: 対象ViewController!

    override func setUp() {
        super.setUp()

        folderName = "フォルダ名"

        recordMode = SnapshotTest.recordMode
    }

    func test対象ViewController_スナップショット条件() {
        // viewMode: ナビゲーション含めるか
        // viewFrame: サイズ指定をするか(デフォルト = UIScreen.main.bounds)
        // viewAfter: 遅延させるか
        // viewAction: 何かしらの処理をおこなうか
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}