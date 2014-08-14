import Foundation

public func future<T>(f: () -> T) -> Future<T> {
    return future(NSOperationQueue.mainQueue(), f)
}

public func future<T>(queue: NSOperationQueue, f: () -> T) -> Future<T> {
    let promise = Promise<T>()
    queue.addOperationWithBlock { () -> Void in
        promise.resolve(f())
    }
    return promise.future
}