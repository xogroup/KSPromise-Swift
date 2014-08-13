import Foundation

public class Deferred<T> {
    public let promise: Promise<T> = Promise()
    
    public init() { }
    
    public func resolve(value: T) {
        promise.complete(FailableOf<T>(value))
    }
    
    public func reject(error: NSError) {
        promise.complete(FailableOf<T>(error))
    }
}
