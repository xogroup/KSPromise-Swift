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
}

public class TryValueWrapper<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}
