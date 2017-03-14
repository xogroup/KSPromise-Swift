import XCTest
import KSPromise

class Future_async_Tests: XCTestCase {
    func test_future_resolvesAFutureFromTheBlock() {
        let myFuture: Future<String> = Future() {
            return Try("A")
        }

        let expectation = self.expectation(description: "resolveFuture")

        myFuture.onSuccess() { (v) in
            expectation.fulfill()
            XCTAssertEqual("A", v, "value is incorrect")
        }

        waitForExpectations(timeout: 1, handler: { error in
        })
    }

    func test_future_withQueue_resolvesAFutureFromTheBlock() {
        let myFuture: Future<String> = Future(queue: OperationQueue.main) {
            return Try("A")
        }

        let expectation = self.expectation(description: "resolveFuture")

        myFuture.onSuccess() { (v) in
            expectation.fulfill()
            XCTAssertEqual("A", v, "value is incorrect")
        }

        waitForExpectations(timeout: 1, handler: { error in
        })
    }

}
