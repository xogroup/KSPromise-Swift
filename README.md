Promises for Swift
(loosely inspired by Scala futures)

# Examples

## Creating a promise object and returning its future 

```swift
let promise = Promise<String>()
return promise.future
```

## Adding callback to the future

```swift
future.onSuccess() { (value) in
    ... do Stuff
    println(v)
}

future.onFailure() { (error) in
    ... handle error
}

future.onComplete() { (value) in
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

## Chaining futures

```swift
let mappedFuture = future.map() { (v) -> FailableOf<String> in
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

mappedFuture.onSuccess() { (value) in
    # value will be result of original future passed
    # through mapped promise function
}
```

## Resolving a promise

```swift
promise.resolve("VALUE")
```

## Rejecting a promise

```swift
let someError = NSError(...)
promise.reject(someError);
```

## Author

* [Kurtis Seebaldt](mailto:kurtis@pivotallabs.com), Pivotal Labs

Copyright (c) 2014 Kurtis Seebaldt. This software is licensed under the MIT License.
