import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoListViewController!
    private var cancellables: Set<AnyCancellable> = .init()

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
            viewAfter: 0.3
        )
    }

    func testMemoListViewController_件数中() {
        dataInsert(count: 8)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 1200
            ),
            viewAfter: 0.3
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
                height: 2800
            ),
            viewAfter: 0.3
        )
    }
}

private extension MemoListViewControllerSnapshotTest {
    func dataInsert(count: Int) {
        (1 ... count).forEach { num in
            CoreDataStorage<Memo>().create().sink {
                $0.category = .init(rawValue: num % 5)
                $0.title = "memo title\(num)"
                $0.content = "memo content\(num)"
                $0.identifier = "identifier\(num)"
            }
            .store(in: &cancellables)
        }
    }
}
