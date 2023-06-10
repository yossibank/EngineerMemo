import Combine
@testable import EngineerMemo
import XCTest

final class WithLatestFromPublisherTest: XCTestCase {
    func test_withLatestFromPublisher_両方のPublisherの値を購読できること() throws {
        // arrange
        let mainSubject = CurrentValueSubject<[Int], Never>([1, 2, 3])
        let subSubject = CurrentValueSubject<[Int], Never>([4, 5, 6])

        // act
        let expectation = XCTestExpectation(description: #function)
        let cancellable = mainSubject
            .withLatestFrom(subSubject) { ($0, $1) }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()

                    case .finished:
                        break
                    }

                    expectation.fulfill()
                },
                receiveValue: { mainValue, subValue in
                    // assert
                    XCTAssertEqual(mainValue, [1, 2, 3])
                    XCTAssertEqual(subValue, [4, 5, 6])
                }
            )

        mainSubject.send(completion: .finished)
        subSubject.send(completion: .finished)

        cancellable.cancel()

        wait(for: expectation, timeout: 1.0)
    }

    func test_withLatestFromPublisher_引数側のPublisherの値を購読できること() throws {
        // arrange
        let mainSubject = CurrentValueSubject<[Int], Never>([1, 2, 3])
        let subSubject = CurrentValueSubject<[Int], Never>([4, 5, 6])

        // act
        let expectation = XCTestExpectation(description: #function)
        let cancellable = mainSubject
            .withLatestFrom(subSubject)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()

                    case .finished:
                        break
                    }

                    expectation.fulfill()
                },
                receiveValue: { subValue in
                    // assert
                    XCTAssertEqual(subValue, [7, 8, 9])
                }
            )

        subSubject.send([7, 8, 9])

        mainSubject.send(completion: .finished)
        subSubject.send(completion: .finished)

        cancellable.cancel()

        wait(for: expectation, timeout: 1.0)
    }
}
