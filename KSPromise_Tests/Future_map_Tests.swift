import XCTest
import KSPromise

class Future_map_Tests: XCTestCase {
    let promise = Promise<String>()
    
    func test_whenAlreadyResolved_withValue_mapsValue() {
        promise.resolve("A");
        var done = false
        
        let mappedFuture = promise.future.map() { (value) -> Try<String> in
            return Try<String>(value + "B")
        }
        
        mappedFuture.onSuccess() { (value) in
            done = true
            XCTAssertEqual("AB", value, "value passed to success is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenResolved_withValue_mapsValue() {
        var done = false
        
        let mappedFuture = promise.future.map() { (value) -> Try<String> in
            return Try<String>(value + "B")
        }
        
        mappedFuture.onSuccess() { (value) in
            done = true
            XCTAssertEqual("AB", value, "value passed to success is incorrect")
        }
        
        promise.resolve("A");
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenResolved_withValue_returnError_whenMapFunctionReturnsError() {
        var done = false
        
        let mappedFuture = promise.future.map() { (value) -> Try<String> in
            let myError = NSError(domain: "Error After: " + value, code: 123, userInfo: nil)
            return Try<String>(myError)
        }
        
        mappedFuture.onFailure() { (error) in
            done = true
            XCTAssertEqual("Error After: A", error.domain, "value passed to failure is incorrect")
        }
        
        promise.resolve("A");
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenAlreadyResolved_withError_passesThroughError() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error);
        var done = false
        
        let mappedFuture = promise.future.map() { (value) -> Try<String> in
            XCTFail("should not be called")
            return Try<String>("A")
        }
        
        mappedFuture.onFailure() { (error) in
            done = true
            XCTAssertEqual("Error", error.domain, "value passed to failure is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
}
