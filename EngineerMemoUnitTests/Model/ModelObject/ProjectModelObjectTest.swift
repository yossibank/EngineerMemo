@testable import EngineerMemo
import XCTest

final class ProjectModelObjectTest: XCTestCase {
    func test_process_requirementDefinition_valueの文字列が男性であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.requirementDefinition.value,
            "要件定義"
        )
    }

    func test_process_functionalDesign_valueの文字列が女性であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.functionalDesign.value,
            "基本設計"
        )
    }

    func test_process_technicalDesign_valueの文字列がその他であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.technicalDesign.value,
            "詳細設計"
        )
    }

    func test_process_implementation_valueの文字列が未設定であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.implementation.value,
            "実装・単体"
        )
    }

    func test_process_intergrationTesting_valueの文字列が未設定であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.intergrationTesting.value,
            "結合テスト"
        )
    }

    func test_process_systemTesting_valueの文字列が未設定であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.systemTesting.value,
            "総合テスト"
        )
    }

    func test_process_maintenance_valueの文字列が未設定であること() {
        // assert
        XCTAssertEqual(
            ProjectModelObject.Process.maintenance.value,
            "保守・運用"
        )
    }
}
