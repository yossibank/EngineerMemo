import Combine
@testable import EngineerMemo
import XCTest

final class ProfileUpdateSkillViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileUpdateSkillViewModel!

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel()

        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .screenView
            )
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_binding_engineerCareer_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.engineerCareer = .three

        model.skillUpdateHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.engineerCareer,
                3
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_language_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.language = "Swift"

        model.skillUpdateHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.language,
                "Swift"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_languageCareer_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.languageCareer = .four

        model.skillUpdateHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.languageCareer,
                4
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_toeic_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.toeic = 800

        model.skillUpdateHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.toeic,
                800
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }
}

private extension ProfileUpdateSkillViewModelTest {
    func setupViewModel(modelObject: ProfileModelObject = ProfileModelObjectBuilder().build()) {
        model = .init()

        analytics = modelObject.skill == nil
            ? .init(screenId: .profileSkillSetting)
            : .init(screenId: .profileSkillUpdate)

        viewModel = .init(
            modelObject: modelObject,
            model: model,
            analytics: analytics
        )

        viewModel.input.viewDidLoad.send(())
    }
}
