import Combine
@testable import EngineerMemo
import XCTest

final class BasicUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: BasicUpdateViewModel!

    override func tearDown() {
        super.tearDown()

        model = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel(modelObject: nil)

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
        setupViewModel(modelObject: nil)

        viewModel.binding.name = "name"

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.name,
                "name"
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

    func test_binding_birthday_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.birthday = Calendar.date(year: 1900, month: 1, day: 1)

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.birthday,
                Calendar.date(year: 1900, month: 1, day: 1)
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

    func test_binding_gender_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.gender = .man

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.gender,
                .man
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

    func test_binding_email_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.email = "test@test.com"

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.email,
                "test@test.com"
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

    func test_binding_phoneNumber_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.phoneNumber = "012345678"

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.phoneNumber,
                "012345678"
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

    func test_binding_address_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.address = "address"

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.address,
                "address"
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

    func test_binding_station_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(modelObject: nil)

        viewModel.binding.station = "station"

        model.createBasicHandler = {
            // assert
            XCTAssertEqual(
                $0.station,
                "station"
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
        setupViewModel(modelObject: nil)

        model.createBasicHandler = { _ in
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

    func test_input_didTapBarButton_setting_プロフィール作成処理が呼ばれること() {
        // arrange
        setupViewModel(modelObject: nil)

        model.createBasicHandler = { _ in
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
        XCTAssertEqual(model.createBasicCallCount, 1)
    }

    func test_input_didTapBarButton_update_プロフィール更新処理が呼ばれること() {
        // arrange
        setupViewModel(modelObject: ProfileModelObjectBuilder().build())

        model.updateBasicHandler = {
            // assert
            XCTAssertEqual(
                $0,
                ProfileModelObjectBuilder().build()
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

        // assert
        XCTAssertEqual(model.updateBasicCallCount, 1)
    }
}

private extension BasicUpdateViewModelTest {
    func setupViewModel(modelObject: ProfileModelObject?) {
        model = .init()

        analytics = modelObject.isNil
            ? .init(screenId: .basicSetting)
            : .init(screenId: .basicUpdate)

        viewModel = .init(
            modelObject: modelObject,
            model: model,
            analytics: analytics
        )
    }
}
