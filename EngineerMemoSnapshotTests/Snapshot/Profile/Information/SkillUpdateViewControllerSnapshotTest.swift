@testable import EngineerMemo
import iOSSnapshotTestCase

final class SkillUpdateViewControllerSnapshotTest: FBSnapshotTestCase {
    private var subject: SkillUpdateViewController!

    override func setUp() {
        super.setUp()

        folderName = "プロフィールスキル経験設定・更新画面"

        recordMode = SnapshotTest.recordMode
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
    }

    func testSkillUpdateViewController_設定() {
        snapshot(modelObject: ProfileModelObjectBuilder().build())
    }

    func testSkillUpdateViewController_更新() {
        snapshot(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )
    }

    func testSkillUpdateViewController_更新_未設定項目あり() {
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

private extension SkillUpdateViewControllerSnapshotTest {
    func snapshot(modelObject: ProfileModelObject) {
        subject = AppControllers.Profile.Information.Skill.Update(modelObject: modelObject)

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
