import Combine
@testable import EngineerMemo
import XCTest

final class ProfileUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileUpdateViewModel!

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel()

        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual($0, .screenView)
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_binding_name_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.name = "name"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.name, "name")
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_birthday_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.birthday = Calendar.date(year: 1900, month: 1, day: 1)

        model.createHandler = {
            // assert
            XCTAssertEqual($0.birthday, Calendar.date(year: 1900, month: 1, day: 1))
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_gender_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.gender = .man

        model.createHandler = {
            // assert
            XCTAssertEqual($0.gender, .man)
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_email_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.email = "test@test.com"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.email, "test@test.com")
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_phoneNumber_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.phoneNumber = "012345678"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.phoneNumber, "012345678")
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_address_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.address = "address"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.address, "address")
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_binding_station_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        viewModel.binding.station = "station"

        model.createHandler = {
            // assert
            XCTAssertEqual($0.station, "station")
        }

        // act
        viewModel.input.didTapSaveButton.send(())
    }

    func test_input_saveButtonTapped_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.didTapSaveButton.send(())

        // arrange
        XCTAssertTrue(viewModel.output.isFinished!)
    }

    func test_input_buttonTapped_update_プロフィール更新処理が呼ばれること() {
        // arrange
        setupViewModel(.update(ProfileModelObjectBuilder().build()))

        // act
        viewModel.input.didTapSaveButton.send(())

        // arrange
        XCTAssertEqual(model.updateCallCount, 1)
    }

    func test_input_buttonTapped_setting_プロフィール作成処理が呼ばれること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.didTapSaveButton.send(())

        // arrange
        XCTAssertEqual(model.createCallCount, 1)
    }
}

private extension ProfileUpdateViewModelTest {
    func setupViewModel(_ type: ProfileUpdateType = .setting) {
        model = .init()

        switch type {
        case .setting:
            analytics = .init(screenId: .profileUpdate)
            viewModel = .init(
                model: model,
                modelObject: nil,
                analytics: analytics
            )

        case let .update(modelObject):
            analytics = .init(screenId: .profileUpdate)
            viewModel = .init(
                model: model,
                modelObject: modelObject,
                analytics: analytics
            )
        }

        viewModel.input.viewDidLoad.send(())
    }
}
