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

        model.getHandler = {
            $0(.success(ProfileModelObjectBuilder().build()))
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
        model.getHandler = {
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
            XCTAssertEqual($0, .screenView)
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_input_didTapIconChangeButton_routing_showIconScreenが呼び出されること() {
        // act
        viewModel.input.didTapIconChangeButton.send(())

        // assert
        XCTAssertEqual(routing.showIconScreenCallCount, 1)
    }

    func test_input_didTapEditButton_routing_showUpdateScreenが呼び出されること() {
        // arrange
        let modelObject = ProfileModelObjectBuilder().build()

        routing.showUpdateScreenHandler = {
            // assert
            XCTAssertEqual($0, .update(modelObject))
        }

        // act
        viewModel.input.didTapEditButton.send(modelObject)

        // assert
        XCTAssertEqual(routing.showUpdateScreenCallCount, 1)
    }

    func test_input_didTapSettingButton_routing_showUpdateScreenが呼び出されること() {
        // arrange
        routing.showUpdateScreenHandler = {
            XCTAssertEqual($0, .setting)
        }

        // act
        viewModel.input.didTapSettingButton.send(())

        // assert
        XCTAssertEqual(routing.showUpdateScreenCallCount, 1)
    }
}
