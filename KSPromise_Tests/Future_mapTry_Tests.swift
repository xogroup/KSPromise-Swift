import XCTest
@testable import KSPromise

class Future_mapTry_Tests: XCTestCase {
    let promise = Promise<String>()

    func test_whenAlreadyResolved_withValue_mapsValue() {
        promise.resolve("A");
        var done = false

        let mappedFuture = promise.future.mapTry() { (v) -> Try<String> in
            switch (v) {
            case .success(let value):
                return Try<String>(value + "B")
            default:
                return v
            }
        }

        mappedFuture.onSuccess() { (v) in
            done = true
            XCTAssertEqual("AB", v, "value passed to success is incorrect")
        }

        XCTAssert(done, "callback not called")
    }

    func test_whenResolved_withValue_mapsValue() {
        var done = false

        let mappedFuture = promise.future.mapTry() { (v) -> Try<String> in
            switch (v) {
            case .success(let value):
                return Try<String>(value + "B")
            default:
                return v
            }
        }

        mappedFuture.onSuccess() { (v) in
            done = true
            XCTAssertEqual("AB", v, "value passed to success is incorrect")
        }

        promise.resolve("A");

        XCTAssert(done, "callback not called")
    }

    func test_whenResolved_withValue_returnError_whenMapFunctionReturnsError() {
        var done = false

        let mappedFuture = promise.future.mapTry() { (v) -> Try<String> in
            switch (v) {
            case .success(let value):
                let myError = NSError(domain: "Error After: " + value, code: 123, userInfo: nil)
                return Try<String>(myError)
            default:
                return v
            }
        }

        mappedFuture.onFailure() { (v) in
            done = true
            XCTAssertEqual("Error After: A", v.domain, "value passed to failure is incorrect")
        }

        promise.resolve("A");

        XCTAssert(done, "callback not called")
    }

    func test_whenAlreadyResolved_withError_mapsError() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error);
        var done = false

        let mappedFuture = promise.future.mapTry() { (v) -> Try<String> in
            switch (v) {
            case .failure(let e):
                let myError = NSError(domain: "Nested Error: " + e.domain, code: 123, userInfo: nil)
                return Try<String>(myError)
            default:
                return v
            }
        }

        mappedFuture.onFailure() { (v) in
            done = true
            XCTAssertEqual("Nested Error: Error", v.domain, "value passed to failure is incorrect")
        }

        XCTAssert(done, "callback not called")
    }

    func test_whenAlreadyResolved_withError_returnsValue_whenMapFunctionReturnsValue() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error);
        var done = false

        let mappedFuture = promise.future.mapTry() { (v) -> Try<String> in
            switch(v) {
            case .failure(let e):
                let value = "Recovered From: " + e.domain
                return Try<String>(value)
            default:
                return v
            }
        }

        mappedFuture.onSuccess() { (v) in
            done = true
            XCTAssertEqual("Recovered From: Error", v, "value passed to success is incorrect")
        }

        XCTAssert(done, "callback not called")
    }

}
