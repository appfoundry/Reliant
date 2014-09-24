Reliant
=======

[![Reliant build status](https://travis-ci.org/appfoundry/Reliant.svg?branch=master)](https://travis-ci.org/appfoundry/reliant)   [![Cocoapods Version](https://cocoapod-badges.herokuapp.com/v/Reliant/badge.png)](http://cocoadocs.org/docsets/Reliant/)

Reliant is a Dependency Injection ([DI](http://martinfowler.com/articles/injection.html "Martin Fowler never lies")) 
framework for Objective-C, both for OS X and iOS. Its goal is to make its use as simple
as possible, while not limiting possibilities. It aims to have as little impact as
possible on your project code. It also aims to be loyal to Objective-C's [dynamic](http://stackoverflow.com/questions/125367/dynamic-type-languages-versus-static-type-languages) 
nature.

Getting started
---------------

In this section we will get you started with Reliant as quick as possible, if you want to know more 
(or in other words, the TL;DR version) we suggest you take a look at our [wiki pages](https://github.com/appfoundry/Reliant/wiki)

### Installation

The easiest way to install Reliant is via CocoaPods

Add the following line to your Podfile:

`pod 'Reliant'`

Then run `pod install` or `pod update`

> for more information about CocoaPods, go to http://cocoapods.org

### Using Reliant

We suggest that you first take a look at our quick-start sample app, found under the [Examples folder](https://github.com/appfoundry/Reliant/tree/master/Examples/HelloReliant) 
in the Reliant repository. You can also download the entire repository [here](https://github.com/appfoundry/Reliant/archive/master.zip).
 
#### Configuration

You first need a context in which Reliant will look for your specific objects. The default way to configure such a 
context is through a configuration class. The example contains some of these. The application wide context is configured
with the `AppConfiguration` class.

```objective-c
//Header file omitted

@implementation AppConfiguration

- (id<StringProvider>)createSingletonStringProvider {
    return [[DefaultStringProvider alloc] init];
}

@end
```

In this very simple example we have the concept of a `StringProvider` which will generate some strings shown by various
views in our application. We configure Reliant to create a "singleton" instance of this string provider. The reason why
you would use dependency injection is that you can avoid hard dependencies to implementations. That's why we have
a `StringProvider` protocol. The configuration will create an actual implementation instance, but that instance is hidden 
from the actual dependent application code. In this case we use the `DefaultStringProvider`.

#### Bootstrapping a context

Bootstrapping a context is very simple. Since we have a configuration for a context which is meant to be used 
throughout the entire application, we will bootstrap this context in the application delegate.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];
}
```

This single line of code is the easiest way to bootstrap a context. It wil start the context with the specified 
configuration class, and then bind that context to `self` which in this case means your application delegate.

#### Injection

Reliant injects all your objects specified in the configuration. Injection can be done in two ways:
- Initializer injection
- Property injection

For simplicity's sake we will use property injection in these examples.

> We actually prefer initializer injection over property injection, but we will get into that in our [wiki pages](https://github.com/appfoundry/Reliant/wiki).

Let's say that our `DefaultStringProvider` implementation needs a `StringGenerator` to generate some strings. 
We could do this by simply adding a property named `stringGenerator` on our `DefaultStringProvider`.
 
```objective-c
@interface DefaultStringProvider : NSObject<StringProvider>

@property (nonatomic, strong) id<StringGenerator> stringGenerator;

@end
```

Now we just need to add another configuration method to our `AppConfiguration` class.

```objective-c
//Inside the implementation of our AppConfiguration

- (id<StringGenerator>)createSingletonStringGenerator {
    return [[DefaultStringGenerator alloc] init];
}
```

With that, when you start your application, both the `DefaultStringProvider` and `DefaultStringGenerator` are being 
created for the AppDelegate's context. Remember when we said they were created as "singletons"? Well, they are not real 
singletons, but they are in the `AppDelegate` context. When you ask the context for this object, it will always return
the same instance, guaranteed.

> For those of you who prefer to put the property in an anonymous class extension, as we do, that would work as well.

After the creation of an object, it will be injected with other objects known by the context it is created for. So in this 
case the `DefaultStringGenerator` is injected in the `DefaultStringProvider` through its `stringGenerator` property.
 
You easily succeeded in loosly coupling the `StringGenerator` to your `DefaultStringProvider` class.

#### Manual injection

It might not always be possible to configure your objects through Reliant. For instance, a view controller might get created
by a storyboard or by your applications code somewhere. In these cases Reliant will not be able to inject your object 
automatically. However, injecting an object is a one-liner again:

```objective-c
[self ocsInject];
```

This will locate a context based on `self`, and then inject `self`with objects known to the found context.

#### Naming your objects

Reliant figures out which objects to inject by their given name. In this case, the names of our object are `stringProvider`
and `stringGenerator`. That is why we named the property in `DefaultStringProvider` as such. The names of the objects are
specified by your configurator. In this case Reliant derives the name from the method names. All text which comes after the 
`createSingleton` is seen as a name. The tentative reader might argue that the names should be *StringGenerator* and 
*StringProvider* (with starting capital), in fact that is true. However, Reliant has created aliases for these objects
in their camelcase form.

Further reading
---------------

Do not forget to check our [wiki pages](https://github.com/appfoundry/Reliant/wiki) for more details on what is discussed above.
Our API documentation is available via [cocoadocs.org](http://cocoadocs.org/docsets/Reliant)

Contact
-------
If not via GitHub, find us on twitter: @AppFoundryBE or @mikeseghers

Licence
-------

Reliant is released under [MIT licence](http://opensource.org/licenses/MIT)
