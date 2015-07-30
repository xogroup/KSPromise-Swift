import Foundation

public class Future<T> {
    
    var _value: Try<T>?
    var _isCompleted = false
    
    var successCallbacks: Array<T -> Void> = []
    var failureCallbacks: Array<NSError -> Void> = []
    var completeCallbacks: Array<Try<T> -> Void> = []
    
    internal init() { }
    
    public convenience init(f: () -> Try<T>) {
        self.init(queue: NSOperationQueue.mainQueue(), f: f)
    }
    
    public init(queue: NSOperationQueue, f: () -> Try<T>) {
        queue.addOperationWithBlock() {
            self.complete(f())
        }
    }
    
    public var value: Try<T>? {
        get {
            return _value
        }
    }
    
    public var isCompleted: Bool {
        get {
            return _isCompleted
        }
    }
    
    public func onComplete(callback: (Try<T>) -> Void) {
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
                case .Success(let wrapper):
                    callback(wrapper.value)
                default:
                    break;
                }
            }
        } else {
            successCallbacks.append(callback)
        }
    }
    
    public func onFailure(callback: (NSError) -> Void) {
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
    
    public func map<U>(transform: (T) -> Try<U>) -> Future<U> {
        let future = Future<U>()
        
        onComplete() { (v) in
            future.complete(v.flatMap(transform))
        }
        return future
    }
    
    public func mapTry<U>(transform: (Try<T>) -> Try<U>) -> Future<U> {
        let promise = Future<U>()
        
        onComplete({ (v: Try<T>) -> Void in
            promise.complete(transform(v))
        })
        return promise
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
    
    public func flatMapTry<U>(transform: (Try<T>) -> Future<U>) -> Future<U> {
        let future = Future<U>()
        
        onComplete() { (v1) in
            let newFuture = transform(v1)
            newFuture.onComplete() { (v2) in
                future.complete(v2)
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
        case .Success(let wrapper):
            for callback in successCallbacks {
                callback(wrapper.value)
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
        case .Success(let wrapper):
            return transform(wrapper.value)
        case .Failure(let error):
            let newFuture = Future<U>()
            newFuture.complete(Try(error))
            return newFuture
        }
    }
}
