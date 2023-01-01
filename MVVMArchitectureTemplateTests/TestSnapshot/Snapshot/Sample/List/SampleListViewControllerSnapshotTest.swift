import iOSSnapshotTestCase
@testable import MVVMArchitectureTemplate
import OHHTTPStubs
import OHHTTPStubsSwift

final class SampleListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SampleListViewController!

    override func setUp() {
        super.setUp()

        folderName = "Sample一覧画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func testSampleListViewController_少件数() {
        snapshotVerifyView(mock: .short)
    }

    func testSampleListViewController_中件数() {
        snapshotVerifyView(mock: .medium)
    }

    func testSampleListViewController_多件数() {
        snapshotVerifyView(mock: .long)
    }
}

private extension SampleListViewControllerSnapshotTest {
    enum APIMock: String {
        case short
        case medium
        case long

        var height: CGFloat {
            let height = UIScreen.main.bounds.height

            switch self {
            case .short:
                return height

            case .medium:
                return height * 2

            case .long:
                return height * 4
            }
        }
    }

    func snapshotVerifyView(mock: APIMock) {
        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "snapshot_sample_list_\(mock.rawValue).json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        subject = AppControllers.Sample.List()

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width,
                height: mock.height
            )
        )
    }
}
