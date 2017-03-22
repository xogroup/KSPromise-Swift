import Foundation

open class Promise<T> {
    open let future: Future<T> = Future()

    public init() { }

    open func resolve(_ value: T) {
        future.complete(Try<T>(value))
    }

    open func reject(_ error: NSError) {
        future.complete(Try<T>(error))
    }
}
