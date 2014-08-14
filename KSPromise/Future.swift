import Foundation

public class Future<T> {
    
    var _value: Try<T>?
    var _isCompleted = false
    
    var successCallbacks: Array<T -> Void>
    var failureCallbacks: Array<NSError -> Void>
    var completeCallbacks: Array<Try<T> -> Void>
    
    public init() {
        successCallbacks = []
        failureCallbacks = []
        completeCallbacks = []
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
        let promise = Future<U>()
        
        onComplete() { (v) in
            var newValue: Try<U>
            switch v {
            case .Success(let wrapper):
                newValue = transform(wrapper.value)
            case .Failure(let error):
                newValue = Try<U>(error)
            }
            promise.complete(newValue)
        }
        return promise
    }
    
    public func mapTry<U>(transform: (Try<T>) -> Try<U>) -> Future<U> {
        let promise = Future<U>()

        onComplete({ (v: Try<T>) -> Void in
            let newVal = transform(v)
            promise.complete(newVal)
        })
        return promise
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
}
