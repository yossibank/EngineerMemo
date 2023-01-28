import Combine
@testable import EngineerMemo
import XCTest

final class ProfileDetailViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var routing: ProfileDetailRoutingInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileDetailViewModel!

    func test_画面表示_成功_プロフィール情報を取得できること() throws {
        // arrange
        setupViewModel()

        // act
        let publisher = viewModel.output.$modelObject.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            ProfileModelObjectBuilder().build()
        )
    }

    func test_画面表示_失敗_エラー情報を取得できること() throws {
        // arrange
        setupViewModel(isSuccess: false)

        // act
        let publisher = viewModel.output.$appError.collect(1).first()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output.first,
            .init(dataError: .coreData(.something("CoreDataエラー")))
        )
    }

    func test_viewWillAppear_firebaseAnalytics_screenViewイベントを送信できること() {
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
}

private extension ProfileDetailViewModelTest {
    func setupViewModel(isSuccess: Bool = true) {
        model = .init()
        routing = .init()
        analytics = .init(screenId: .profileDetail)

        if isSuccess {
            model.getHandler = { result in
                result(.success(ProfileModelObjectBuilder().build()))
            }
        } else {
            model.getHandler = { result in
                result(.failure(.init(dataError: .coreData(.something("CoreDataエラー")))))
            }
        }

        viewModel = .init(
            model: model,
            routing: routing,
            analytics: analytics
        )
    }
}
