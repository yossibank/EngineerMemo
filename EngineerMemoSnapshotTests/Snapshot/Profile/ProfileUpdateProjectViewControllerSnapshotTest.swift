@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileUpdateProjectViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileUpdateProjectViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィール案件設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testProfileUpdateProjectViewController_設定() {
        snapshot(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )
    }

    func testProfileUpdateProjectViewController_更新() {
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

private extension ProfileUpdateProjectViewControllerSnapshotTest {
    func snapshot(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        subject = AppControllers.Profile.Update.Project(
            identifier: identifier,
            modelObject: modelObject
        )

        snapshotVerifyView(viewMode: .navigation(subject))
    }
}
