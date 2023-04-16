import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoListViewController!
    private var cancellables: Set<AnyCancellable> = .init()

    private let storage = CoreDataStorage<Memo>()

    override func setUp() {
        super.setUp()

        folderName = "メモ一覧画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Memo.List()
    }

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testMemoListViewController_件数少() {
        dataInsert(count: 1)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.1
        )
    }

    func testMemoListViewController_件数中() {
        dataInsert(count: 8)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewAfter: 0.1
        )
    }

    func testMemoListViewController_件数多() {
        dataInsert(count: 20)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 1500
            ),
            viewAfter: 0.1
        )
    }
}

private extension MemoListViewControllerSnapshotTest {
    func dataInsert(count: Int) {
        (1 ... count).forEach { num in
            storage.create().sink {
                $0.identifier = "identifier\(num)"
                $0.title = "memo title\(num)"
                $0.content = "memo content\(num)"
            }
            .store(in: &cancellables)
        }
    }
}
