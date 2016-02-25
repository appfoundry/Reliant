# Reliant/Swift design document

### Design

Reliant/Swift requires Swift 2. The initial draft was created by Mike Seghers in January 2016 and aims to port Reliant/ObjC's main ideas to Swift.

The main protocol in Reliant is `ReliantContext`, which provides a place to configure and persist dependencies.

```swift
public protocol ReliantContext {
    typealias ContextType

    static func createContext() -> ContextType
}
```

Contexts simply adopt the `ReliantContext` protocol and implement the `createContext()` method. In most cases it simply defers to the  initializer, e.g.:

```swift
class SimpleValueContext : ReliantContext {
    let viewModel:SomeViewModel = ConcreteViewModel()
    
    static func createContext() -> SimpleValueContext {
        return SimpleValueContext()
    }
}
```

Objects managed by the context can then be accessed through the top level function `relyOn()`, e.g.:

```swift
class SomeClass {
    private let authViewModel = relyOn(AppContext).authViewModel   
}
```

### Remarks

(add remarks)
