import Combine
@testable import EngineerMemo
import XCTest

final class ProfileListViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var routing: ProfileListRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileListViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .profileList)
        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.fetchHandler = {
            Deferred {
                Future<[ProfileModelObject], AppError> { promise in
                    promise(.success([ProfileModelObjectBuilder().build()]))
                }
            }
            .eraseToAnyPublisher()
        }
    }

    override func tearDown() {
        super.tearDown()

        model = nil
        routing = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewDidLoad_成功_プロフィール情報を取得できること() throws {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            ProfileModelObjectBuilder().build()
        )
    }

    func test_input_viewDidLoad_失敗_エラー情報を取得できること() throws {
        // arrange
        model.fetchHandler = {
            Deferred {
                Future<[ProfileModelObject], AppError> { promise in
                    promise(.failure(AppError(dataError: .coreData(.something("エラー")))))
                }
            }
            .eraseToAnyPublisher()
        }

        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$appError.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            .init(dataError: .coreData(.something("エラー")))
        )
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
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

    func test_input_didTapIconChangeButton_routing_showIconScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showIconScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                modelObject
            )
        }

        // act
        viewModel.input.didTapIconChangeButton.send(modelObject)

        // assert
        XCTAssertEqual(
            routing.showIconScreenCallCount,
            1
        )
    }

    func test_input_didTapBasicSettingButton_routing_showBasicUpdateScreenが呼び出されること() {
        // arrange
        routing.showBasicUpdateScreenHandler = {
            // assert
            XCTAssertNil($0)
        }

        // act
        viewModel.input.didTapBasicSettingButton.send(nil)

        // assert
        XCTAssertEqual(
            routing.showBasicUpdateScreenCallCount,
            1
        )
    }

    func test_input_didTapSkillSettingButton_routing_showSkillUpdateScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showSkillUpdateScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                modelObject
            )
        }

        // act
        viewModel.input.didTapSkillSettingButton.send(modelObject)
    }

    func test_input_didChangeProjectSortType_model_updateProfileProjectSortTypeが呼び出されること() {
        // arrange
        model.updateProfileProjectSortTypeHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .ascending
            )
        }

        // act
        viewModel.input.didChangeProjectSortType.send(.ascending)
    }

    func test_input_didTapProjectCreateButton_routing_showProjectCreateScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showProjectCreateScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                modelObject
            )
        }

        // act
        viewModel.input.didTapProjectCreateButton.send(modelObject)
    }

    func test_input_didSelectProjectCell_routing_showProjectDetailScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showProjectDetailScreenHandler = {
            // assert
            XCTAssertEqual($0, "identifier")
            XCTAssertEqual($1, modelObject)
        }

        // act
        viewModel.input.didSelectProjectCell.send((
            "identifier",
            modelObject
        ))
    }
}
