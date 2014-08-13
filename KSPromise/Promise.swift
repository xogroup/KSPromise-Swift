import Foundation

public class Promise<T> {
    public let future: Future<T> = Future()
    
    public init() { }
    
    public func resolve(value: T) {
        future.complete(FailableOf<T>(value))
    }
    
    public func reject(error: NSError) {
        future.complete(FailableOf<T>(error))
    }
}
