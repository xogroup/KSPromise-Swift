import Foundation

public enum Try<T> {
    case Success(TryValueWrapper<T>)
    case Failure(NSError)

    public init(_ value: T) {
        self = .Success(TryValueWrapper(value))
    }

    public init(_ error: NSError) {
        self = .Failure(error)
    }

    public func map<U>(f: T -> U) -> Try<U> {
        switch self {
        case Success(let wrapper):
            return .Success(TryValueWrapper(f(wrapper.value)))
        case Failure(let error):
            return .Failure(error)
        }
    }

    public func flatMap<U>(f:T -> Try<U>) -> Try<U> {
        switch self {
        case Success(let wrapper):
            return f(wrapper.value)
        case Failure(let error):
            return .Failure(error)
        }
    }
}

public class TryValueWrapper<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}
