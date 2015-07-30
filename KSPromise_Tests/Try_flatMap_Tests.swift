import XCTest
import KSPromise

class Try_flatMap_Tests: XCTestCase {
    
    func test_flatMap_callsFunctionOnSuccess() {
        let value = Try<String>("A")
        
        let result: Try<String> = value.flatMap() { (v) in
            return Try(v + "B")
        }
        
        switch(result) {
        case .Success(let value):
            XCTAssertEqual(value, "AB", "value was not mapped")
        case .Failure:
            XCTFail("Should not error")
        }
    }
    
    func test_flatMap_passesThroughErrorOnFailure() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let value = Try<String>(error)
        
        let result: Try<String> = value.flatMap() { (v) in
            return Try(v + "B")
        }
        
        switch(result) {
        case .Success:
            XCTFail("Should not succeed")
        case .Failure(let e):
            XCTAssertEqual(e, error, "error does not match")
        }
    }
    
    func test_flatMap_returnsSecondErrorWhenFirstTrySucceeds() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let value = Try<String>("A")
        
        let result: Try<String> = value.flatMap() { (v) in
            return Try(error)
        }
        
        switch(result) {
        case .Success:
            XCTFail("Should not succeed")
        case .Failure(let e):
            XCTAssertEqual(e, error, "error does not match")
        }
    }
    
    func test_flatMap_passesThroughFirstErrorOnFailure() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let error2 = NSError(domain: "Error2", code: 456, userInfo: nil)
        let value = Try<String>(error)
        
        let result: Try<String> = value.flatMap() { (v) in
            return Try(error2)
        }
        
        switch(result) {
        case .Success:
            XCTFail("Should not error")
        case .Failure(let e):
            XCTAssertEqual(e, error, "error does not match")
        }
    }
    
}
