@testable import EngineerResume
import iOSSnapshotTestCase

final class SampleAddViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SampleAddViewController!

    override func setUp() {
        super.setUp()

        folderName = "Sample追加画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Sample.Add()
    }

    func testSampleAddViewController_作成ボタン_有効化() {
        snapshotVerifyView(viewMode: .navigation(subject)) {
            self.subject.viewModel.binding.title = "title"
            self.subject.viewModel.binding.body = "body"
        }
    }

    func testSampleAddViewController_作成ボタン_無効化() {
        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testSampleAddViewController_バリデーション_タイトル_空文字() {
        snapshotVerifyView(viewMode: .navigation(subject)) {
            self.subject.viewModel.binding.title = ""
        }
    }

    func testSampleAddViewController_バリデーション_内容_空文字() {
        snapshotVerifyView(viewMode: .navigation(subject)) {
            self.subject.viewModel.binding.body = ""
        }
    }

    func testSampleAddViewController_バリデーション_タイトル_内容_空文字() {
        snapshotVerifyView(viewMode: .navigation(subject)) {
            self.subject.viewModel.binding.title = ""
            self.subject.viewModel.binding.body = ""
        }
    }
}
