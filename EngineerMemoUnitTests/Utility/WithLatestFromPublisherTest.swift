import Combine
@testable import EngineerMemo
import XCTest

final class WithLatestFromPublisherTest: XCTestCase {
    func test_withLatestFromPublisher_両方のPublisherの値を購読できること() throws {
        // arrange
        let subject1 = CurrentValueSubject<[Int], Never>([])
        let subject2 = CurrentValueSubject<[Int], Never>([4, 5, 6])

        // act
        wait(timeout: 0.5) { expectation in
            let cancellable = subject1
                .withLatestFrom(subject2) { ($0, $1) }
                .sink(
                    receiveCompletion: { _ in
                        expectation.fulfill()
                    },
                    receiveValue: { subject1, subject2 in
                        // assert
                        XCTAssertEqual(
                            subject1,
                            [1, 2, 3]
                        )

                        XCTAssertEqual(
                            subject2,
                            [4, 5, 6]
                        )
                    }
                )

            subject1.send([1, 2, 3])
            subject1.send(completion: .finished)
            subject2.send(completion: .finished)
            cancellable.cancel()
        }
    }

    func test_withLatestFromPublisher_引数側のPublisherの値を購読できること() throws {
        // arrange
        let subject1 = CurrentValueSubject<[Int], Never>([])
        let subject2 = CurrentValueSubject<[Int], Never>([4, 5, 6])

        // act
        wait(timeout: 0.5) { expectation in
            let cancellable = subject1
                .withLatestFrom(subject2)
                .sink(
                    receiveCompletion: { _ in
                        expectation.fulfill()
                    },
                    receiveValue: { subject2 in
                        // assert
                        XCTAssertEqual(
                            subject2,
                            [7, 8, 9]
                        )
                    }
                )

            subject2.send([7, 8, 9])
            subject1.send([1, 2, 3])
            subject1.send(completion: .finished)
            subject2.send(completion: .finished)
            cancellable.cancel()
        }
    }
}
