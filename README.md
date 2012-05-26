Reliant
=======

Reliant is a Dependency Injection (DI) framework for Objective-C, both for OS X and iOS. It's
goal is to make it's use as simple as possible, while not limiting it's possibilities. It
aims to have as little impact as possible on your project code.

The motivation for this library came from being used to a highly testable infrastructure
in other languages thanks to DI. Looking at the typical design pattern to solve the loose
coupling problem, the Factory pattern is the natural solution. Although factories, in
conjunction with mock libraries provide a fairly nice and testable solution, the pure
loose coupling is never reached, since you still have a dependency to a factory in almost
all classes in your project, which is a rather large footprint. Before starting this
library, I looked for opinions about DI in dynamic languages at the one hand, and in
frontend driven solutions at the other hand. Reliant is an answer to these questions.

*Remark* at the moment, Reliant is still under development, and put here for review by the
community. Although we consider the latest version to be pretty complete, there is still
room for improvement. Obviously, since this is open source, do feel free to add your own
insights/ideas/remarks/opinions.

Overall architecture
--------------------

The framework is setup to be lightweight, you basically need an OCSApplicationContext
which serves as the container of the managed objects. To register managed objects in this
container, the application context uses an OCSConfigurator instance. The OCSConfigurator
is responsible for creating OCSDefinitions, which describe the objects you want to put
under the application context's control.

At the moment, Reliant identifies two types of objects: singletons and prototypes. (*These
names are taken from the well know [design patterns](http://en.wikipedia.org/wiki/Software_design_pattern#Classification_and_list)*)

- A singleton is a stateless shared object, which is created only once (might be more then
once cfr. memory warnings). Objects created as singleton should be thread safe! Reliant
further identifies eager and lazy singletons. Eager means that they will be instantiated
when the application context boots up, lazy means they will be instantiated
*Just-in-Time*, when they are requested.

- A prototype will be created each time it is requested from the application context. Be
carefull though! If you inject a prototype into a singleton, the prototype's livecycle is
bound to the singleton!

Objects are identified by a key and can have aliases, both strings. The framework makes
sure these are unique. Exceptions will be thrown if an attempt is made to add an object
with a non-unique key or alias.

Now let's look at a Quick start example.

Quick start
-----------

### Bootstrapping Reliant

To get started with Reliant, you need to tell the *OCSApplicationContext* to start up. You
will need to provide a configurator instance to the application context. More on
configurators later, bare with us for now.

```objective-c
//Initialize a configurator
id<OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[YourObjectFactory class]];

//Initialize the application context with the configurator
OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];

//Start the context
[context start];

//Done! Well...
```

This will bootstrap the entire application context. At the time the start method finishes
it's job, it will have loaded your defintions and it will have instantiated and injected
your eager singletons.

Now where should you put this peace of code? As close as possible to where the application
startup. For iOS this means in the [application:didFinishLaunchingWithOptions:](http://developer.apple.com/library/ios/documentation/uikit/reference/UIApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:didFinishLaunchingWithOptions:) 
method in your UIApplicationDelegate. For OS X this is almost the same:
[applicationDidFinishLaunching:](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/NSApplicationDelegate/applicationDidFinishLaunching:)
 in your NSApplicationDelegate.
 
### Using the *OCSConfiguratorFromClass*

This is a ready-made configurator implementation. It uses the information found in a class
provided by you through introspection. The provided class will also serve as the creator
of your objects, hence we will call it a factory class. The idea behind this is to give
you a programatic way to define objects, and make the configuration itself subject to
testing. This makes the use of external configuration files and/or macros obsolete, which
yields more robust code.

So what you need to use this configurator is a factory class. The methods in this class
will be responsible for creating your objects. In order for the framework to detect these
methods, you will need to follow some naming conventions on them.

OCSConfiguratorFromClass will detect 4 kinds of methods. (Replace YourObjectKey each time with a unique name)

```objective-c
- (id) createSingleton/*YourObjectKey*/; //Lazy singleton definition
- (id) createEagerSingleton/*YourObjectKey*/; //Eager singleton definition
- (id) createPrototype/*YourObjectKey*/;//Prototype definition
- (NSArray *) aliasesFor/*YourObjectKey*/;//Alias definitions
```
Let's look at them in more detail:

#### Defining singletons

For each lazy singleton you need, you should add a method with the following signature:

```objective-c
- (id) createSingletonFoo {
	return [[[Foo alloc] init] autorelease];
}
```

You can also use what is called *constructor injection* by calling another 
*createSingleton* or *createEagerSingleton* method:

```objective-c
- (id) createSingletonBar {
	return [[[Bar alloc] initWithSomeObject:[self createSingletonFoo]] autorelease];
}
```

Don't worry about calling the same *createSingleton* method more then once, the framework
will only realy call each method once and reuse the same result on the succeeding calls,
making the results true singletons.

You don't necessarily need to inject your objects through constructor injection. Later on
we will explain how objects are injected through the use of properties.

To create eager singletons, add this kind of method:

```objective-c
- (id) createEagerSingletonFooBar {
	return [[[FooBar alloc] init] autorelease];
}
```

#### Defining prototypes

For creating prototypes we can use a similar approach. Only the method name changes a bit:

```objective-c
- (id) createPrototype {
	return [[[FooBar alloc] init] autorelease];
}
```

**Remember:** each time a prototype is requested this method will be called. You should 
therefore consider to keep the initialization as performant as possible.

#### Registering aliases for an object

Registering aliases for an object is also possible. Again, you just need to add a method
with a certain signature:

```objective-c
- (NSArray *) aliasesForFoo {
	return [NSSet setWithObjects:@"_foo", @"_fuu", nil];
}
```

*Remark:* by default, two aliases are already registered for each object. They take the
form of the key in uppercase (eg. FOO, BAR, FOOBAR, ...) and the key starting with a
lowercase (eg. foo, bar, fooBar, ...). Aliases must be unique, and should also never be
equal to an object key. If an attempt is made to add a duplicate, an exception will be
raised. The automatically added aliases, will only be added if they are not a duplicate of
the key.

#### Other methods in your factory class

You can add other methods, which might help in creating your objects. These will be
ignored by the framework, but you can obviously use them in your create methods.

#### Dealing with larger applications

In larger applications, the factory class can quickly become huge. This is where you can
and should use Objective C's
[category](http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/objectivec/chapters/occategories.html "Objective-C programming language reference")
mechanism. For each logical group of objects you can create a category, named after this
logical group. All methods in all categories of your factory class will be taken into
account. It might look something like this (interfaces will be omitted for brevity).

```objective-c
@implementation ReliantFactory

- (id) createSingletonGeneralObject {
	return ...;
}

@end

@implementation ReliantFactory (Services)

- (id) createEagerSingletonServiceA {
	return [[[ServiceA alloc] init] autorelease];
}

- (id) createEagerSingletonServiceB {
	return [[[ServiceB alloc] init] autorelease];
}

@end

@implementation ReliantFactory (Repositories)

- (id) createEagerSingletonRepositoryA {
	return [[[RepositoryA alloc] init] autorelease];
}

- (id) createEagerSingletonRepositoryB {
	return [[[RepositoryB alloc] init] autorelease];
}

@end

```

### Injection

All objects created in the application context will be injected after their creation. This
is done as explained before by *constructor injection* and/or by using Objective-C's 
[KVC](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html "Key-Value Coding Programming Guide")
mechanism. Reliant will scan your object's properties. If a writable property's name
matches with a key or alias for an object in the application context, and if it's current
value is nil, the matching object will be injected in this property. All other properties
will be left alone.

#### Injecting objects that are not know to the application context

You can use the injection mechanism described above on objects which are not setup in the 
application context. A good example would be a UIViewController. In order to make things
easier, you kan make use of the fact that we have bootstrapped our application context in
the UIApplicationDelegate. Since the UIApplication is a shared object (hey, another
singleton!) we can do our injection from here.

This is what you need to do:

```objective-c
//In your UIApplicationDelegate
@implementation MyAppDelegate {
	OCSApplicationContext *_context;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//...
	
	//Initialize a configurator
	id<OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[YourObjectFactory class]];

	//Initialize the application context with the configurator
	_context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];

	//Start the context
	[_context start];
	
	//...

}

- (void) performInjectionOn:(id) object {
	[_context performInjectionOn:object];
}

@end;

//In your UIViewController
@implementation MyViewController

@synthesize foo;

- (void) setup {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate performInjectionOn:self];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

@end
```

And that's all there is to it. The property foo will be injected.

### The configurator

As we already saw, a configurator is responsible for setting up definitions and creating
object instance based on those definitions. Although a default class configurator
(*OCSConfiguratorFromClass*) is provided by Reliant, you can always build your own. Your
custom configurator should conform to the *OCSConfigurator* protocol. In the
configurator's designated initializer, you should start building your object definitions.
A configurator, although not enforced, should maintain it's own definition registry. A
configurator should not start creating instances for these definitions just until the
contextLoaded: message is send to it. Only after all work is done should the configurator
return objects through its objectForKey:inContext: method. When work is done, the
initializing property should be true/YES/whatever-other-bool-literal-you-prefer.

*Remark* Although the framework is extendible, we encourage you to use the provided
configurator.

#### Example

```objective-c
//  CustomConfigurator.h

@interface CustomConfigurator : OCSBaseConfigurator

@end


// CustomConfigurator.m

TODO

@end
```

Interesting references/discussions
----------------------------------

- [Discussion](http://stackoverflow.com/questions/309711/dependency-injection-framework-for-cocoa "StackOverflow") on the necessity of DI in Objective C/Dynamic languages 

Inspirational projects / credits
--------------------------------

- [Spring framework](http://www.springsource.org/spring-framework#documentation "SpringSource Spring framework"). 
I dare say this is the de facto standard IoC container in the Java world. 
Although going much (much ... much) further then DI, this framework was one of if not the 
pioneer in DI framework. Since spring 3.0, a Configuration class system is available. Reliant
builds on this principle.

- [Guice](http://code.google.com/p/google-guice/ "Google Guice"). Google's type safe DI 
solution. Partially as an answer to spring, which was not very strong on the type-safety 
side of things at that time. Spring fixed this in version 3.0.
Although Guice is a very well thought of DI framework, which should be marvelled for it's
simplicity and light-weightness, I personally feel that basing a DI framework for a dynamic 
language on Guice is a bridge too far. It breaks down too many of the main goals of Guice, 
namely type safety. I'm not saying type safety is unimportant, I'm just saying that
Objective C (and other dynamic languages for that matter) take a different approach.

- [Objection](http://objection-framework.org/ "AtomicObject Objection"). Another DI
framework for Objective C, based on Guice. As stated before, the "binding" approach did
look appealing to me at first, but after considering that the *type safety* isn't really
there. But still, a very well made port.

Special thanks
--------------

- Filip Maelbrancke: for second opinions and rubber ducking
- iDA MediaFoundry: for letting me use this in production code
- Oak Consultancy Services: for necessary resources
- Liesbet Gouwy: for unconditional support
- Kato Seghers: for being born

Contact
-------
If not via GitHub, find me on twitter: @mikeseghers

Licence
-------

Reliant is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)