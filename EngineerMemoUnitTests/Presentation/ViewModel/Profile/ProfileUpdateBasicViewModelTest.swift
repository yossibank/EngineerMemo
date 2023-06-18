import Combine
@testable import EngineerMemo
import XCTest

final class ProfileUpdateBasicViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileUpdateBasicViewModel!

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

    func test_binding_name_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.name = "name"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.name,
                "name"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_birthday_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.birthday = Calendar.date(year: 1900, month: 1, day: 1)

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.birthday,
                Calendar.date(year: 1900, month: 1, day: 1)
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_gender_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.gender = .man

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.gender,
                .man
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_email_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.email = "test@test.com"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.email,
                "test@test.com"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_phoneNumber_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.phoneNumber = "012345678"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.phoneNumber,
                "012345678"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_address_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.address = "address"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.address,
                "address"
            )
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_station_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.station = "station"

        model.createHandler = {
            // assert
            XCTAssertEqual(
                $0.station,
                "station"
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

    func test_input_didTapBarButton_setting_プロフィール作成処理が呼ばれること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(model.createCallCount, 1)
    }

    func test_input_didTapBarButton_update_プロフィール更新処理が呼ばれること() {
        // arrange
        setupViewModel(modelObject: ProfileModelObjectBuilder().build())

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(model.basicUpdateCallCount, 1)
    }
}

private extension ProfileUpdateBasicViewModelTest {
    func setupViewModel(modelObject: ProfileModelObject? = nil) {
        model = .init()

        analytics = modelObject.isNil
            ? .init(screenId: .profileBasicSetting)
            : .init(screenId: .profileBasicUpdate)

        viewModel = .init(
            modelObject: modelObject,
            model: model,
            analytics: analytics
        )

        viewModel.input.viewDidLoad.send(())
    }
}
