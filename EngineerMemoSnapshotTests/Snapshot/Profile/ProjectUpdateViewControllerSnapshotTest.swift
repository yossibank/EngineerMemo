@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProjectUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProjectUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール案件設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testProjectUpdateViewController_設定() {
        snapshot(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )
    }

    func testProjectUpdateViewController_更新() {
        snapshot(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .title("title")
                        .role("programmer")
                        .content("content")
                        .startDate(Calendar.date(year: 2020, month: 3, day: 1))
                        .endDate(Calendar.date(year: 2022, month: 5, day: 1))
                        .identifier("identifier")
                        .build()
                ])
                .build()
        )
    }
}

private extension ProjectUpdateViewControllerSnapshotTest {
    func snapshot(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        subject = AppControllers.Profile.Project.Update(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIWindow.windowFrame.width,
                height: 1500
            )
        )
    }
}
