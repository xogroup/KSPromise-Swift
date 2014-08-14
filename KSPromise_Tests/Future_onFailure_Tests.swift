import XCTest
import KSPromise

class Future_onFailure_Tests: XCTestCase {
    let promise = Promise<String>()
    
    func test_whenAlreadyRejected_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        promise.reject(error)
        
        var done = false
        
        promise.future.onFailure() { (e) in
            done = true
            XCTAssertEqual(error, e, "error passed to failure is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_whenRejected_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        var done = false
        
        promise.future.onFailure() { (e) in
            done = true
            XCTAssertEqual(error, e, "error passed to failure is incorrect")
        }
        
        promise.reject(error)
        
        XCTAssert(done, "callback not called")
    }
}
