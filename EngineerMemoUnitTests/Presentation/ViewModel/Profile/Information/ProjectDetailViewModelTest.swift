import Combine
@testable import EngineerMemo
import XCTest

final class ProjectDetailViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var routing: ProjectDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProjectDetailViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        routing = .init()
        analytics = .init(screenId: .projectDetail)
        viewModel = .init(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder()
                .projects([ProjectModelObjectBuilder().build()])
                .build(),
            model: model,
            routing: routing,
            analytics: analytics
        )

        model.findHandler = { _ in
            Deferred {
                Future<ProfileModelObject, AppError> { promise in
                    promise(
                        .success(
                            ProfileModelObjectBuilder()
                                .projects([ProjectModelObjectBuilder().build()])
                                .build()
                        )
                    )
                }
            }
            .eraseToAnyPublisher()
        }

        viewModel.input.viewDidLoad.send(())
    }

    override func tearDown() {
        super.tearDown()

        model = nil
        routing = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewDidLoad_案件情報を取得できること() throws {
        // arrange
        viewModel.input.viewDidLoad.send(())

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first

        // assert
        XCTAssertEqual(
            output,
            ProjectModelObjectBuilder().build()
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

    func test_input_didTapEditBarButton_routing_showUpdateScreenが呼び出されること() {
        // arrange
        routing.showUpdateScreenHandler = { identifier, modelObject in
            // assert
            XCTAssertEqual(
                identifier,
                "identifier"
            )

            XCTAssertEqual(
                modelObject,
                ProfileModelObjectBuilder()
                    .projects([ProjectModelObjectBuilder().build()])
                    .build()
            )
        }

        // act
        viewModel.input.didTapEditBarButton.send(())
    }

    func test_input_didTapDeleteBarButton_output_isDeletedがtrueを取得できること() throws {
        // act
        viewModel.input.didTapDeleteBarButton.send(())

        let publisher = viewModel.output.$isDeleted.collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertTrue(output)
    }
}
