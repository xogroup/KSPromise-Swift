import XCTest
import XOPromise

class Future_onComplete_Tests: XCTestCase {
    let promise = Promise<String>()

    func test_whenAlreadyResolved_withValue_callsCallback() {
        promise.resolve("A")

        var done = false

        promise.future.onComplete() { (v) in
            done = true
            switch (v) {
            case .success(let value):
                XCTAssertEqual("A", value, "value passed to success is incorrect")
            default:
                XCTFail("should not have failed")
            }
        }

        XCTAssert(done, "callback not called")
    }

    func test_whenResolved_withValue_callsCallback() {
        var done = false

        promise.future.onComplete() { (v) in
            done = true
            switch (v) {
            case .success(let value):
                XCTAssertEqual("A", value, "value passed to success is incorrect")
            default:
                XCTFail("should not have failed")
            }
        }

        promise.resolve("A")

        XCTAssert(done, "callback not called")
    }

    func test_whenAlreadyResolved_withError_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error)

        var done = false

        promise.future.onComplete() { (v) in
            done = true
            switch (v) {
            case .failure(let e):
                XCTAssertEqual(error, e, "error passed to failure is incorrect")
            default:
                XCTFail("should not have succeeded")
            }
        }

        XCTAssert(done, "callback not called")
    }

    func test_whenResolved_withError_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        var done = false

        promise.future.onComplete() { (v) in
            done = true

            switch(v) {
            case .failure(let e):
                XCTAssertEqual(error, e, "error passed to failure is incorrect")
            default:
                XCTFail("should not have succeeded")
            }
        }

        promise.reject(error)

        XCTAssert(done, "callback not called")
    }

}
