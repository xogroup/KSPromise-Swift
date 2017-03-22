import XCTest
import XOPromise

class Future_onSuccess_Tests: XCTestCase {
    let promise = Promise<String>()

    func test_whenAlreadyResolved_callsCallback() {
        promise.resolve("A")

        var done = false

        promise.future.onSuccess() { (v) in
            done = true
            XCTAssertEqual("A", v, "value passed to success is incorrect")
        }

        XCTAssert(done, "callback not called");
    }

    func test_whenResolved_callsCallback() {
        var done = false

        promise.future.onSuccess() { (v) in
            done = true
            XCTAssertEqual("A", v, "value passed to success is incorrect")
        }

        promise.resolve("A")

        XCTAssert(done, "callback not called")
    }
}
