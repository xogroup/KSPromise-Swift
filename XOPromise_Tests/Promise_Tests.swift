import XCTest
import XOPromise

class Promise_Tests: XCTestCase {
    let promise = Promise<String>()

    func test_resolvingPromiseASecondTime_doesNotUpdateValue() {
        promise.resolve("A");
        promise.resolve("B");

        if let value = promise.future.value {
            switch value {
            case .success(let value):
                XCTAssertEqual(value, "A", "value should not have updated")
            case .failure:
                XCTFail("should not have failed")
            }

        } else {
            XCTFail("value was not set")
        }
    }

    func test_resolvingPromiseASecondTime_doesNotCallCallbacks() {
        var count = 0

        promise.future.onSuccess() { (v) in
            count += 1
        }

        promise.resolve("A");
        promise.resolve("B");

        XCTAssertEqual(1, count, "callback was called too many times")
    }

    func test_rejectingPromiseASecondTime_doesNotUpdateValue() {
        let error1 = NSError(domain: "error1", code: 123, userInfo: nil)
        let error2 = NSError(domain: "error2", code: 456, userInfo: nil)

        promise.reject(error1)
        promise.reject(error2)

        if let value = promise.future.value {
            switch value {
            case .success:
                XCTFail("should not have succeeded")
            case .failure(let error):
                XCTAssertEqual(error, error1, "value should not have updated")
            }
        } else {
            XCTFail("value was not set")
        }
    }

    func test_rejectingPromiseASecondTime_doesNotCallCallbacks() {
        let error1 = NSError(domain: "error1", code: 123, userInfo: nil)
        let error2 = NSError(domain: "error2", code: 456, userInfo: nil)
        var count = 0

        promise.future.onFailure() { (v) in
            count += 1
        }

        promise.reject(error1)
        promise.reject(error2)

        XCTAssertEqual(1, count, "callback was called too many times")
    }
}
