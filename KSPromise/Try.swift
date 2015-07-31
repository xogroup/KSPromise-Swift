import Foundation

public enum Try<T> {
    case Success(T)
    case Failure(ErrorType)

    public init(_ value: T) {
        self = .Success(value)
    }

    public init(_ error: ErrorType) {
        self = .Failure(error)
    }

    public func map<U>(f: T -> U) -> Try<U> {
        switch self {
        case Success(let value):
            return .Success(f(value))
        case Failure(let error):
            return .Failure(error)
        }
    }

    public func flatMap<U>(f:T -> Try<U>) -> Try<U> {
        switch self {
        case Success(let value):
            return f(value)
        case Failure(let error):
            return .Failure(error)
        }
    }
}

