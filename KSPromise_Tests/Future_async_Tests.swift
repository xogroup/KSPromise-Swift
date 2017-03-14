import XCTest
import KSPromise

class Future_async_Tests: XCTestCase {
    func test_future_resolvesAFutureFromTheBlock() {
        let myFuture: Future<String> = Future() {
            return Try("A")
        }

        let expectation = expectationWithDescription("resolveFuture")

        myFuture.onSuccess() { (v) in
            expectation.fulfill()
            XCTAssertEqual("A", v, "value is incorrect")
        }

        waitForExpectationsWithTimeout(1, handler: { error in
        })
    }

    func test_future_withQueue_resolvesAFutureFromTheBlock() {
        let myFuture: Future<String> = Future(queue: NSOperationQueue.mainQueue()) {
            return Try("A")
        }

        let expectation = expectationWithDescription("resolveFuture")

        myFuture.onSuccess() { (v) in
            expectation.fulfill()
            XCTAssertEqual("A", v, "value is incorrect")
        }

        waitForExpectationsWithTimeout(1, handler: { error in
        })
    }

}
