import XCTest
import KSPromise

class Future_function_Tests: XCTestCase {
    func test_future_resolvesAFutureFromTheBlock() {
        let myFuture: Future<String> = future {
            return "A"
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
        let myFuture: Future<String> = future(NSOperationQueue.mainQueue()) {
            return "A"
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
