import XCTest
import KSPromise

class Try_map_Tests: XCTestCase {

    func test_map_callsFunctionOnSuccess() {
        let value = Try<String>("A")

        let result: Try<String> = value.map() { (v) in
            return v + "B"
        }

        switch(result) {
        case .Success(let wrapper):
            XCTAssertEqual(wrapper.value, "AB", "value was not mapped")
        case .Failure:
            XCTFail("Should not error")
        }
    }

    func test_map_passesThroughErrorOnFailure() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let value = Try<String>(error)

        let result: Try<String> = value.map() { (v) in
            return v + "B"
        }

        switch(result) {
        case .Success:
            XCTFail("Should not error")
        case .Failure(let e):
            XCTAssertEqual(e, error, "error does not match")
        }
    }

}
