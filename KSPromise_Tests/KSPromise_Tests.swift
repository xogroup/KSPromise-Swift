import XCTest
import KSPromise

class KSPromise_iOSTests: XCTestCase {
    let deferred = Deferred<String>()
    
    func test_onSuccess_whenAlreadyResolved_callsCallback() {
        deferred.resolve("A")
        
        var done = false
        
        deferred.promise.onSuccess() { (v) in
            done = true
            XCTAssertEqual("A", v, "value passed to success is incorrect")
        }
        
        XCTAssert(done, "callback not called");
    }
    
    func test_onSuccess_whenResolved_callsCallback() {
        var done = false
        
        deferred.promise.onSuccess() { (v) in
            done = true
            XCTAssertEqual("A", v, "value passed to success is incorrect")
        }
        
        deferred.resolve("A")
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onFailure_whenAlreadyRejected_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        deferred.reject(error)
        
        var done = false
        
        deferred.promise.onFailure() { (e) in
            done = true
            XCTAssertEqual(error, e, "error passed to failure is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onFailure_whenRejected_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        var done = false
        
        deferred.promise.onFailure() { (e) in
            done = true
            XCTAssertEqual(error, e, "error passed to failure is incorrect")
        }
        
        deferred.reject(error)
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onComplete_whenAlreadyResolved_withValue_callsCallback() {
        deferred.resolve("A")
        
        var done = false
        
        deferred.promise.onComplete() { (v) in
            done = true
            switch (v) {
            case .Success(let wrapper):
                XCTAssertEqual("A", wrapper.value, "value passed to success is incorrect")
            default:
                XCTFail("should not have failed")
            }
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onComplete_whenResolved_withValue_callsCallback() {
        var done = false
        
        deferred.promise.onComplete() { (v) in
            done = true
            switch (v) {
            case .Success(let wrapper):
                XCTAssertEqual("A", wrapper.value, "value passed to success is incorrect")
            default:
                XCTFail("should not have failed")
            }
        }
        
        deferred.resolve("A")
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onComplete_whenAlreadyResolved_withError_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        deferred.reject(error)
        
        var done = false
        
        deferred.promise.onComplete() { (v) in
            done = true
            switch (v) {
            case .Failure(let e):
                XCTAssertEqual(error, e, "error passed to failure is incorrect")
            default:
                XCTFail("should not have succeeded")
            }
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_onComplete_whenResolved_withError_callsCallback() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        var done = false
        
        deferred.promise.onComplete() { (v) in
            done = true
            
            switch(v) {
            case .Failure(let e):
                XCTAssertEqual(error, e, "error passed to failure is incorrect")
            default:
                XCTFail("should not have succeeded")
            }
        }
        
        deferred.reject(error)
        
        XCTAssert(done, "callback not called")
    }
    
    func test_map_whenAlreadyResolved_withValue_mapsValue() {
        deferred.resolve("A");
        var done = false
        
        let mappedPromise = deferred.promise.map() { (v) -> FailableOf<String> in
            switch (v) {
            case .Success(let wrapper):
                return FailableOf<String>(wrapper.value + "B")
            default:
                return v
            }
        }
        
        mappedPromise.onSuccess() { (v) in
            done = true
            XCTAssertEqual("AB", v, "value passed to success is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_map_whenResolved_withValue_mapsValue() {
        var done = false
        
        let mappedPromise = deferred.promise.map() { (v) -> FailableOf<String> in
            switch (v) {
            case .Success(let wrapper):
                return FailableOf<String>(wrapper.value + "B")
            default:
                return v
            }
        }
        
        mappedPromise.onSuccess() { (v) in
            done = true
            XCTAssertEqual("AB", v, "value passed to success is incorrect")
        }

        deferred.resolve("A");
        
        XCTAssert(done, "callback not called")
    }
    
    func test_map_whenResolved_withValue_returnError_whenMapFunctionReturnsError() {
        var done = false
        
        let mappedPromise = deferred.promise.map() { (v) -> FailableOf<String> in
            switch (v) {
            case .Success(let wrapper):
                let myError = NSError(domain: "Error After: " + wrapper.value, code: 123, userInfo: nil)
                return FailableOf<String>(myError)
            default:
                return v
            }
        }
        
        mappedPromise.onFailure() { (v) in
            done = true
            XCTAssertEqual("Error After: A", v.domain!, "value passed to failure is incorrect")
        }
        
        deferred.resolve("A");
        
        XCTAssert(done, "callback not called")
    }
    
    func test_map_whenAlreadyResolved_withError_mapsError() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        deferred.reject(error);
        var done = false
        
        let mappedPromise = deferred.promise.map() { (v) -> FailableOf<String> in
            switch (v) {
            case .Failure(let e):
                let myError = NSError(domain: "Nested Error: " + e.domain!, code: 123, userInfo: nil)
                return FailableOf<String>(myError)
            default:
                return v
            }
        }
        
        mappedPromise.onFailure() { (v) in
            done = true
            XCTAssertEqual("Nested Error: Error", v.domain!, "value passed to failure is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
    func test_map_whenAlreadyResolved_withError_returnsValue_whenMapFunctionReturnsValue() {
        let error = NSError(domain: "Error", code: 123, userInfo: nil)
        deferred.reject(error);
        var done = false
        
        let mappedPromise = deferred.promise.map() { (v) -> FailableOf<String> in
            switch(v) {
            case .Failure(let e):
                let value = "Recovered From: " + e.domain
                return FailableOf<String>(value)
            default:
                return v
            }
        }
        
        mappedPromise.onSuccess() { (v) in
            done = true
            XCTAssertEqual("Recovered From: Error", v, "value passed to success is incorrect")
        }
        
        XCTAssert(done, "callback not called")
    }
    
}
