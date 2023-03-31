import Combine
@testable import EngineerMemo
import XCTest

final class ProfileIconViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var modelObject: ProfileModelObject!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProfileIconViewModel!

    override func setUp() {
        super.setUp()

        model = .init()
        modelObject = ProfileModelObjectBuilder().build()
        analytics = .init(screenId: .profileIcon)
        viewModel = .init(
            model: model,
            modelObject: modelObject,
            analytics: analytics
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

    func test_input_didChangeIconData_ProfileModelObjectのiconImageが更新されること() {
        // arrange
        let iconImage = Asset.penguin.image.pngData()

        model.iconImageUpdateHandler = {
            // assert
            XCTAssertEqual($0.iconImage, iconImage)
        }

        // act
        viewModel.input.didChangeIconData.send(iconImage)
    }

    func test_input_didChangeIconIndex_ProfileModelにindex値を送信できること() {
        // arrange
        model.iconImageUpdateIndexHandler = {
            // assert
            XCTAssertEqual($0, 2)
        }

        // act
        viewModel.input.didChangeIconIndex.send(2)
    }
}
