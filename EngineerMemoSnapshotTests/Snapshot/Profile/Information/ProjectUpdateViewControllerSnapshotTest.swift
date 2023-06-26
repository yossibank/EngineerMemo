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
                        .content("content")
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
        subject = AppControllers.Profile.Information.Project.Update(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
