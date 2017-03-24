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

    static func future(with value: T) -> Future<T> {
        let promise = Promise<T>()
        promise.resolve(value)
        return promise.future
    }

    static func future(with error: NSError) -> Future<T> {
        let promise = Promise<T>()
        promise.reject(error)
        return promise.future
    }
}
