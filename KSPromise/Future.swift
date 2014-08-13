import Foundation

public class Future<T> {
    
    var value: FailableOf<T>?
    var isCompleted = false
    
    var successCallbacks: Array<T -> Void>
    var failureCallbacks: Array<NSError -> Void>
    var completeCallbacks: Array<FailableOf<T> -> Void>
    
    public init() {
        successCallbacks = []
        failureCallbacks = []
        completeCallbacks = []
    }
    
    public func onComplete(callback: (FailableOf<T>) -> Void) {
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
    
    public func map<U>(transform: (FailableOf<T>) -> FailableOf<U>) -> Future<U> {
        let promise = Future<U>()

        onComplete({ (v: FailableOf<T>) -> Void in
            let newVal = transform(v)
            promise.complete(newVal)
        })
        return promise
    }
    
    internal func complete(value: FailableOf<T>) {
        self.isCompleted = true
        self.value = value
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
    }
}
