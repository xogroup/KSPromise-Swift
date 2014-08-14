import XCTest
import KSPromise

class Future_flatMap_Tests: XCTestCase {
    let promise = Promise<String>()
    
    func test_whenAlreadyResolved_withValue_mapsValueToSecondFuture_andResolvesToFinalValue() {
        promise.resolve("A");
        var done = false
        
        let promise2 = Promise<String>()
        promise2.resolve("B")
        
        let flatMappedFuture = promise.future.flatMap() { (v1) -> Future<String> in
            promise2.future.map() { (v2) -> Try<String> in
                return Try(v1 + v2)
            }
        }
        
        flatMappedFuture.onSuccess() { (value) in
            done = true
            XCTAssertEqual("AB", value, "value passed to success is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenAlreadyRejected_withError_mapsValue() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error)
        var done = false
        
        let promise2 = Promise<String>()
        promise2.resolve("B")
        
        let flatMappedFuture = promise.future.flatMap() { (v1) -> Future<String> in
            promise2.future.map() { (v2) -> Try<String> in
                return Try(v1 + v2)
            }
        }
        
        flatMappedFuture.onFailure() { (e) in
            done = true
            XCTAssertEqual(e, error, "incorrect error passed through")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenMappedFutureFails_returnsFinalError() {
        promise.resolve("A");
        var done = false
        
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        let promise2 = Promise<String>()
        promise2.reject(error)
        
        let flatMappedFuture = promise.future.flatMap() { (v1) -> Future<String> in
            promise2.future
        }
        
        flatMappedFuture.onFailure() { (e) in
            done = true
            XCTAssertEqual(e, error, "incorrect error passed through")
        }
        
        XCTAssert(done, "callback not called")
    }
 }
