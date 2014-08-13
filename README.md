Promises for Swift

# Examples

## Creating a deferred object and returning its promise 

```swift
let deferred = Deferred<String>()
return deferred.promise
```

## Adding callback to the promise

```swift
promise.onSuccess() { (value) in
    ... do Stuff
    println(v)
}

promise.onFailure() { (error) in
    ... handle error
}

promise.onComplete() { (value) in
    switch (value) {
    case .Success(let wrapper):
        # call wrapper.value to get actual value
        # workaround because Swift can not compile
        # enums with generic types
        println(wrapper.value)
    case .Failue(let error):
        ... handle error
    }
}
```

## Chaining promises

```swift
let mappedPromise = promise.map() { (v) -> FailableOf<String> in
    switch (v) {
    case .Success(let wrapper):
        let newValue = f(wrapper.value)
        return FailableOf<String>(newValue)
    case .Failue(let error):
        # handle error
        # or pass through
        return v
    }
}

mappedPromise.onSuccess() { (value) in
    # value will be result of original promise passed
    # through mapped promise function
}
```

## Resolving a promise

```swift
deferred.resolve("VALUE")
```

## Rejecting a promise

```swift
let someError = NSError(...)
[deferred reject:someError];
```

## Author

* [Kurtis Seebaldt](mailto:kurtis@pivotallabs.com), Pivotal Labs

Copyright (c) 2014 Kurtis Seebaldt. This software is licensed under the MIT License.
