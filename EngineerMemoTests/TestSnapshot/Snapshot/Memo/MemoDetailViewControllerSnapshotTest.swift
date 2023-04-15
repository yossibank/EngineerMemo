import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase
import OHHTTPStubs
import OHHTTPStubsSwift

final class MemoDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoDetailViewController!
    private var cancellables: Set<AnyCancellable> = .init()

    private let storage = CoreDataStorage<Memo>()

    override func setUp() {
        super.setUp()

        folderName = "メモ詳細画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Memo.Detail(identifier: "identifier")
    }

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testMemoDetailViewController_短文() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .title("title")
                .content("content")
                .build()
        )

        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testMemoDetailViewController_標準() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 10))
                .content(String(repeating: "content ", count: 20))
                .build()
        )

        snapshotVerifyView(viewMode: .navigation(subject))
    }

    func testMemoDetailViewController_長文() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 30))
                .content(String(repeating: "content ", count: 60))
                .build()
        )

        snapshotVerifyView(viewMode: .navigation(subject))
    }
}

private extension MemoDetailViewControllerSnapshotTest {
    func dataInsert(modelObject: MemoModelObject) {
        storage.create().sink {
            $0.identifier = "identifier"
            $0.title = modelObject.title
            $0.content = modelObject.content
        }
        .store(in: &cancellables)
    }
}
