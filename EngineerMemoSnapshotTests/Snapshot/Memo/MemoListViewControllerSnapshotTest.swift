import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoListViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "メモ一覧画面"

        recordMode = SnapshotTest.recordMode

        subject = AppControllers.Memo.List()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func testMemoListViewController_件数0() {
        snapshotVerifyView(viewMode: .navigation(subject))
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
                width: UIWindow.windowFrame.width,
                height: 1300
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
                width: UIWindow.windowFrame.width,
                height: 2900
            ),
            viewAfter: 0.3
        )
    }
}

private extension MemoListViewControllerSnapshotTest {
    func dataInsert(count: Int) {
        (1 ... count).forEach { num in
            CoreDataStorage<Memo>().create().sink {
                $0.object.category = .init(rawValue: num % 6)
                $0.object.title = "memo title\(num)"
                $0.object.content = "memo content\(num)"
                $0.object.identifier = "identifier\(num)"
                $0.context.saveIfNeeded()
            }
            .store(in: &cancellables)
        }
    }
}
