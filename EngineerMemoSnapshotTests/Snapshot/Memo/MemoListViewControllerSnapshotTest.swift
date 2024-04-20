import Combine
@testable import EngineerMemo
import iOSSnapshotTestCase

final class MemoListViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: MemoListViewController!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        folderName = "memo_list"

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
            viewAfter: 0.5
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
                height: 1500
            ),
            viewAfter: 0.5
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
                height: 3200
            ),
            viewAfter: 0.5
        )
    }
}

private extension MemoListViewControllerSnapshotTest {
    func dataInsert(count: Int) {
        for num in 1 ... count {
            CoreDataStorage<Memo>().create().sink {
                $0.object.category = .init(rawValue: num % 7)
                $0.object.title = "memo title\(num)"
                $0.object.content = "memo content\(num)"
                $0.object.identifier = "identifier\(num)"
                $0.object.createdAt = .init()
                $0.context.saveIfNeeded()
            }
            .store(in: &cancellables)
        }
    }
}
