import Combine
@testable import EngineerMemo
import XCTest

final class SkillUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: SkillUpdateViewModel!

    override func tearDown() {
        super.tearDown()

        model = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel(modelObject: ProfileModelObjectBuilder().build())

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
        setupViewModel(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        viewModel.binding.engineerCareer = .three

        model.insertSkillHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.engineerCareer,
                3
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_language_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        viewModel.binding.language = "Swift"

        model.insertSkillHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.language,
                "Swift"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_languageCareer_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        viewModel.binding.languageCareer = .four

        model.insertSkillHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.languageCareer,
                4
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_toeic_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        viewModel.binding.toeic = 800

        model.insertSkillHandler = {
            // assert
            XCTAssertEqual(
                $0.skill?.toeic,
                800
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel(
            modelObject: ProfileModelObjectBuilder()
                .skill(SKillModelObjectBuilder().build())
                .build()
        )

        model.insertSkillHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }
}

private extension SkillUpdateViewModelTest {
    func setupViewModel(modelObject: ProfileModelObject) {
        model = .init()

        analytics = modelObject.skill.isNil
            ? .init(screenId: .skillSetting)
            : .init(screenId: .skillUpdate)

        viewModel = .init(
            modelObject: modelObject,
            model: model,
            analytics: analytics
        )
    }
}
