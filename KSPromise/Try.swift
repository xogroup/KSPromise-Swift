import Foundation

public enum Try<T> {
    case success(TryValueWrapper<T>)
    case failure(NSError)

    public init(_ value: T) {
        self = .success(TryValueWrapper(value))
    }

    public init(_ error: NSError) {
        self = .failure(error)
    }

    public func map<U>(_ f: (T) -> U) -> Try<U> {
        switch self {
        case .success(let wrapper):
            return .success(TryValueWrapper(f(wrapper.value)))
        case .failure(let error):
            return .failure(error)
        }
    }

    public func flatMap<U>(_ f:(T) -> Try<U>) -> Try<U> {
        switch self {
        case .success(let wrapper):
            return f(wrapper.value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

open class TryValueWrapper<T> {
    open let value: T
    public init(_ value: T) { self.value = value }
}
