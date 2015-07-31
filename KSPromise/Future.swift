import Foundation

public class Future<T> {
    
    var _value: T?
    var _isCompleted = false
    
    var successCallbacks: Array<T -> Void> = []
    var failureCallbacks: Array<ErrorType -> Void> = []
    var completeCallbacks: Array<T -> Void> = []
    
    internal init() { }
    
    public convenience init(f: () -> Try<T>) {
        self.init(queue: NSOperationQueue.mainQueue(), f: f)
    }
    
    public init(queue: NSOperationQueue, f: () -> Try<T>) {
        queue.addOperationWithBlock() {
            self.complete(f())
        }
    }
    
    public var value: T? {
        get {
            return _value
        }
    }
    
    public var isCompleted: Bool {
        get {
            return _isCompleted
        }
    }
    
    public func onComplete(callback: (T) -> Void) {
        if isCompleted {
            callback(value!)
        } else {
            completeCallbacks.append(callback)
        }
    }
    
    public func onSuccess(callback: (T) -> Void) {
        if isCompleted {
            if let v = value {
                switch(v) {
                case .Success(let value):
                    callback(value)
                default:
                    break;
                }
            }
        } else {
            successCallbacks.append(callback)
        }
    }
    
    public func onFailure(callback: (ErrorType) -> Void) {
        if isCompleted {
            if let v = value {
                switch(v) {
                case .Failure(let error):
                    callback(error)
                default:
                    break;
                }
            }
        } else {
            failureCallbacks.append(callback)
        }
    }
    
    public func map<U>(transform: (T) throws -> U) -> Future<U> {
        let future = Future<U>()
        
        onComplete() { (v) in
            do {
                let mappedValue = try transform(v)
                future.complete(Try(mappedValue))
            } catch {
                future.complete(Try(error))
            }
            
        }
        return future
    }
    
    public func flatMap<U>(transform: (T) -> Future<U>) -> Future<U> {
        let future = Future<U>()
        
        onComplete() { (v) in
            let newFuture = self.buildFlatMapFuture(v, transform: transform)
            newFuture.onComplete() { (v) in
                future.complete(v)
            }
        }
        return future
    }
    
    internal func complete(value: Try<T>) {
        if isCompleted {
            return
        }
            
        _isCompleted = true
        _value = value
        switch (value) {
        case .Success(let value):
            for callback in successCallbacks {
                callback(value)
            }
        case .Failure(let error):
            for callback in failureCallbacks {
                callback(error)
            }
        }
        for callback in completeCallbacks {
            callback(self.value!)
        }
        successCallbacks.removeAll(keepCapacity: false)
        failureCallbacks.removeAll(keepCapacity: false)
        completeCallbacks.removeAll(keepCapacity: false)
    }
    
    private func buildFlatMapFuture<U>(v: Try<T>, transform: (T) -> Future<U>) -> Future<U> {
        switch v {
        case .Success(let value):
            return transform(value)
        case .Failure(let error):
            let newFuture = Future<U>()
            newFuture.complete(Try(error))
            return newFuture
        }
    }
}
