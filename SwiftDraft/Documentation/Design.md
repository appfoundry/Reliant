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

Contexts simply adopt the `ReliantContext` protocol and implement the `createContext()` method. In many cases it simply defers to the  initializer, e.g.:

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

#### 1. Direct reference to context class everywhere

**Alex**: 
We talked about mocking away the `relyOn(..)` function, but I think the main issue is the fact that a direct reference to a concrete context class will be spread across the entire code base. This indeed makes it difficult to switch contexts, e.g. in stub/mock or test configurations.
