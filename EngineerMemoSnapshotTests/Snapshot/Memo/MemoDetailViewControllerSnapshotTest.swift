import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoDetailViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoDetailViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "MemoDetail"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Memo.Detail(identifier: "identifier")
    }

    override func tearDown() {
        super.tearDown()

        subject = nil

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testMemoDetailViewController_短文() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .category(.todo)
                .title("title")
                .content("content")
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.5
        )
    }

    func testMemoDetailViewController_標準() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .category(.technical)
                .title("title ".repeat(10))
                .content("content ".repeat(20))
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.5
        )
    }

    func testMemoDetailViewController_長文() {
        dataInsert(
            modelObject: MemoModelObjectBuilder()
                .category(.event)
                .title("title ".repeat(30))
                .content("content ".repeat(60))
                .build()
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.5
        )
    }
}

private extension MemoDetailViewControllerSnapshotTest {
    func dataInsert(modelObject: MemoModelObject) {
        CoreDataStorage<Memo>().create().sink {
            $0.object.category = .init(rawValue: modelObject.category?.rawValue ?? .invalid)
            $0.object.title = modelObject.title
            $0.object.content = modelObject.content
            $0.object.identifier = "identifier"
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
