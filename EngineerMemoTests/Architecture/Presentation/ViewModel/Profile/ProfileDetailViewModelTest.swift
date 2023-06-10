import Combine
@testable import EngineerMemo
import XCTest

final class ProfileDetailViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var routing: ProfileDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileDetailViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .profileDetail)
        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.fetchHandler = {
            $0(
                .success(
                    [ProfileModelObjectBuilder().build()]
                )
            )
        }
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
            $0(.failure(.init(dataError: .coreData(.something("CoreDataエラー")))))
        }

        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$appError.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            .init(dataError: .coreData(.something("CoreDataエラー")))
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

    func test_input_didTapBasicEditButton_routing_showUpdateBasicScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showUpdateBasicScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .update(modelObject)
            )
        }

        // act
        viewModel.input.didTapBasicEditButton.send(modelObject)

        // assert
        XCTAssertEqual(
            routing.showUpdateBasicScreenCallCount,
            1
        )
    }

    func test_input_didTapBasicSettingButton_routing_showUpdateBasicScreenが呼び出されること() {
        // arrange
        routing.showUpdateBasicScreenHandler = {
            XCTAssertEqual(
                $0,
                .setting
            )
        }

        // act
        viewModel.input.didTapBasicSettingButton.send(())

        // assert
        XCTAssertEqual(
            routing.showUpdateBasicScreenCallCount,
            1
        )
    }

    func test_input_didTapSkillEditButton_routing_showUpdateSkillScreenが呼び出されること() {
        // arrange
        let modelObject = SKillModelObjectBuilder().build()

        routing.showUpdateSkillScreenHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .update(modelObject)
            )
        }

        // act
        viewModel.input.didTapSkillEditButton.send(modelObject)

        // assert
        XCTAssertEqual(
            routing.showUpdateSkillScreenCallCount,
            1
        )
    }

    func test_input_didTapSkillSettingButton_routing_showUpdateSkillScreenが呼び出されること() {
        // arrange
        routing.showUpdateSkillScreenHandler = {
            XCTAssertEqual(
                $0,
                .setting
            )
        }

        // act
        viewModel.input.didTapSkillSettingButton.send(())

        // assert
        XCTAssertEqual(
            routing.showUpdateSkillScreenCallCount,
            1
        )
    }
}
