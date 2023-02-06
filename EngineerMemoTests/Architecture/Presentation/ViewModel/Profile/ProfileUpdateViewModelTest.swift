import Combine
@testable import EngineerMemo
import XCTest

final class ProfileUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileUpdateViewModel!

    func test_binding_name_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.name = "name"

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.name, "name")
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_birthday_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.birthday = Calendar.date(year: 1900, month: 1, day: 1)

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.birthday, Calendar.date(year: 1900, month: 1, day: 1))
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_gender_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.gender = .man

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.gender, .man)
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_email_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.email = "test@test.com"

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.email, "test@test.com")
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_phoneNumber_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.phoneNumber = "012345678"

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.phoneNumber, "012345678")
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_address_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.address = "address"

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.address, "address")
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_binding_station_保存ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        viewModel.binding.station = "station"

        model.createHandler = { modelObject in
            XCTAssertEqual(modelObject.station, "station")
            expectation.fulfill()
        }

        // act
        viewModel.input.saveButtonTapped.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_viewWillAppear_設定_firebaseAnalytics_screenViewイベントを送信できていること() {
        // arrange
        setupViewModel()

        let expectation = XCTestExpectation(description: #function)

        analytics.sendEventFAEventHandler = { event in
            // assert
            XCTAssertEqual(event, .screenView)
            expectation.fulfill()
        }

        // act
        viewModel.input.viewWillAppear.send(())

        wait(for: [expectation], timeout: 0.1)
    }

    func test_saveButtonTapped_output_isFinishがtrueを取得できること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.saveButtonTapped.send(())

        // arrange
        XCTAssertTrue(viewModel.output.isFinish!)
    }

    func test_buttonTapped_update_プロフィール更新処理が呼ばれること() {
        // arrange
        setupViewModel(.update(ProfileModelObjectBuilder().build()))

        // act
        viewModel.input.saveButtonTapped.send(())

        // arrange
        XCTAssertEqual(model.updateCallCount, 1)
    }

    func test_buttonTapped_setting_プロフィール作成処理が呼ばれること() {
        // arrange
        setupViewModel()

        // act
        viewModel.input.saveButtonTapped.send(())

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
    }
}
