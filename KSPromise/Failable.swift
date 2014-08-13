import Foundation

public enum FailableOf<T> {
    case Success(FailableValueWrapper<T>)
    case Failure(NSError)

    public init(_ value: T) {
        self = .Success(FailableValueWrapper(value))
    }

    public init(_ error: NSError) {
        self = .Failure(error)
    }
}

public class FailableValueWrapper<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}

