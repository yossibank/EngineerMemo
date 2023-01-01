import iOSSnapshotTestCase
@testable import MVVMArchitectureTemplate

final class SampleEditViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SampleEditViewController!

    private let modelObject = SampleModelObjectBuilder().build()

    override func setUp() {
        super.setUp()

        folderName = "Sample編集画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Sample.Edit(modelObject)
    }

    func testSampleEditViewController_編集ボタン_有効化() {
        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testSampleEditViewController_編集ボタン_無効化() {
        snapshotVerifyView(viewMode: .navigation(subject)) {
            self.subject.viewModel.binding.title = ""
            self.subject.viewModel.binding.body = ""
        }
    }
}
