@testable import EngineerMemo
import iOSSnapshotTestCase

final class ProfileUpdateSkillViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: ProfileUpdateSkillViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィールスキル経験設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    func testProfileUpdateSkillViewController_設定() {
        snapshot()
    }

    func testProfileUpdateSkillViewController_更新() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )
    }

    func testProfileUpdateSkillViewController_更新_未設定項目あり() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .skill(
                    SKillModelObjectBuilder()
                        .engineerCareer(3)
                        .language("Swift")
                        .languageCareer(2)
                        .toeic(nil)
                        .build()
                )
                .build()
        )
    }
}

private extension ProfileUpdateSkillViewControllerSnapshotTest {
    func snapshot(modelObject: ProfileModelObject = ProfileModelObjectBuilder().build()) {
        subject = AppControllers.Profile.Update.Skill(modelObject: modelObject)

        snapshotVerifyView(
            viewMode: .navigation(subject),
            viewFrame: .init(
                x: .zero,
                y: .zero,
                width: UIWindow.windowFrame.width,
                height: 800
            )
        )
    }
}
