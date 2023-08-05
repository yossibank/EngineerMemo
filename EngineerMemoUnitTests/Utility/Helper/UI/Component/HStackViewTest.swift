@testable import EngineerMemo
import XCTest

final class HStackViewTest: XCTestCase {
    func test_HStackView_axis() {
        // arrange
        let stackView = HStackView(builder: {})

        // act
        let value = stackView.axis

        // assert
        XCTAssertEqual(
            value,
            .horizontal
        )
    }

    func test_HStackView_alignment() {
        // arrange
        let stackView1 = HStackView(builder: {})
        let stackView2 = HStackView(alignment: .leading, builder: {})
        let stackView3 = HStackView(alignment: .firstBaseline, builder: {})
        let stackView4 = HStackView(alignment: .center, builder: {})
        let stackView5 = HStackView(alignment: .trailing, builder: {})
        let stackView6 = HStackView(alignment: .lastBaseline, builder: {})
        let stackView7 = HStackView(alignment: .top, builder: {})
        let stackView8 = HStackView(alignment: .bottom, builder: {})

        // act
        let value1 = stackView1.alignment
        let value2 = stackView2.alignment
        let value3 = stackView3.alignment
        let value4 = stackView4.alignment
        let value5 = stackView5.alignment
        let value6 = stackView6.alignment
        let value7 = stackView7.alignment
        let value8 = stackView8.alignment

        // assert
        XCTAssertEqual(value1, .fill)
        XCTAssertEqual(value2, .leading)
        XCTAssertEqual(value3, .firstBaseline)
        XCTAssertEqual(value4, .center)
        XCTAssertEqual(value5, .trailing)
        XCTAssertEqual(value6, .lastBaseline)
        XCTAssertEqual(value7, .top)
        XCTAssertEqual(value8, .bottom)
    }

    func test_HStackView_distribution() {
        // arrange
        let stackView1 = HStackView(builder: {})
        let stackView2 = HStackView(distribution: .fillEqually, builder: {})
        let stackView3 = HStackView(distribution: .fillProportionally, builder: {})
        let stackView4 = HStackView(distribution: .equalSpacing, builder: {})
        let stackView5 = HStackView(distribution: .equalCentering, builder: {})

        // act
        let value1 = stackView1.distribution
        let value2 = stackView2.distribution
        let value3 = stackView3.distribution
        let value4 = stackView4.distribution
        let value5 = stackView5.distribution

        // assert
        XCTAssertEqual(value1, .fill)
        XCTAssertEqual(value2, .fillEqually)
        XCTAssertEqual(value3, .fillProportionally)
        XCTAssertEqual(value4, .equalSpacing)
        XCTAssertEqual(value5, .equalCentering)
    }

    func test_HStackView_spacing() {
        // arrange
        let stackView1 = HStackView(builder: {})
        let stackView2 = HStackView(spacing: 10, builder: {})
        let stackView3 = HStackView(spacing: 100, builder: {})

        // act
        let value1 = stackView1.spacing
        let value2 = stackView2.spacing
        let value3 = stackView3.spacing

        // assert
        XCTAssertEqual(value1, 0)
        XCTAssertEqual(value2, 10)
        XCTAssertEqual(value3, 100)
    }

    func test_HStackView_layoutMargins() {
        // arrange
        let stackView1 = HStackView(builder: {})
        let stackView2 = HStackView(layoutMargins: .init(top: 10, left: 10, bottom: 10, right: 10), builder: {})
        let stackView3 = HStackView(layoutMargins: .init(top: 100, left: 100, bottom: 100, right: 100), builder: {})

        // act
        let value1 = stackView1.layoutMargins
        let value2 = stackView2.layoutMargins
        let value3 = stackView3.layoutMargins

        // assert
        XCTAssertEqual(value1, .zero)
        XCTAssertEqual(value2, .init(top: 10, left: 10, bottom: 10, right: 10))
        XCTAssertEqual(value3, .init(top: 100, left: 100, bottom: 100, right: 100))
    }

    func test_HStackView_isLayoutMarginsRelativeArrangement() {
        // arrange
        let stackView = HStackView(builder: {})

        // act
        let value = stackView.isLayoutMarginsRelativeArrangement

        // assert
        XCTAssertTrue(value)
    }

    func test_HStackView_stackViewBuilder() {
        // arrange
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()

        // act
        let stackView = HStackView {
            view1
            view2
            view3
        }

        // assert
        XCTAssertEqual(
            stackView.arrangedSubviews,
            [view1, view2, view3]
        )
    }
}
