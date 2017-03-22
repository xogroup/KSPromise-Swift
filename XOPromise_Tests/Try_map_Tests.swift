import XCTest
import XOPromise

class Try_map_Tests: XCTestCase {

    func test_map_callsFunctionOnsuccess() {
        let value = Try<String>("A")

        let result: Try<String> = value.map() { (v) in
            return v + "B"
        }

        switch(result) {
        case .success(let value):
            XCTAssertEqual(value, "AB", "value was not mapped")
        case .failure:
            XCTFail("Should not error")
        }
    }

    func test_map_passesThroughErrorOnfailure() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let value = Try<String>(error)

        let result: Try<String> = value.map() { (v) in
            return v + "B"
        }

        switch(result) {
        case .success:
            XCTFail("Should not error")
        case .failure(let e):
            XCTAssertEqual(e, error, "error does not match")
        }
    }

}
