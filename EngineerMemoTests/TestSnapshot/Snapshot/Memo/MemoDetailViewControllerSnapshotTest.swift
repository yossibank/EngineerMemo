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
    }

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testMemoDetailViewController_短文() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title("title")
                .content("content")
                .build()
        )
    }

    func testMemoDetailViewController_標準() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 10))
                .content(String(repeating: "content ", count: 20))
                .build()
        )
    }

    func testMemoDetailViewController_長文() {
        snapshot(
            modelObject: MemoModelObjectBuilder()
                .title(String(repeating: "title ", count: 30))
                .content(String(repeating: "content ", count: 60))
                .build()
        )
    }
}

extension MemoDetailViewControllerSnapshotTest {
    func dataInsert(modelObject: MemoModelObject) {
        storage.create().sink {
            $0.identifier = "identifier"
            $0.title = modelObject.title
            $0.content = modelObject.content
        }
        .store(in: &cancellables)
    }
}

extension MemoDetailViewControllerSnapshotTest {
    func snapshot(modelObject: MemoModelObject) {
        dataInsert(modelObject: modelObject)
        sleep(UInt32(0.5))
        subject = AppControllers.Memo.Detail(identifier: "identifier")
        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
