Reliant
=======

Reliant is a dependency injection framework for Objective C, specifically targeted, but 
not limited to iOS. It's goal is to make it's use as simple as possible, while not 
limiting it's possibilities. It aims to have as little impact as possible on your project 
code.

The motivation for this library came from being used to a highly testable infrastructure
in other languages thanks to DI. Looking at the typical design pattern to solve the loose
coupling problem, the Factory pattern is the natural solution. Although factories, in
conjunction with mock libraries provide a fairly nice and testable solution, the pure
loose coupling is never reached, since you still have a dependency to a factory in almost
all classes in your project. Before starting this library, I looked for opinions about DI
in dynamic languages at the one hand, and in frontend driven solutions at the other hand.
Reliant is an answer to these questions.

Quick start
-----------

### Bootstrapping Reliant

TODO bind to appdelegate

To get started with Reliant, you need to tell the *OCSApplicationContext* to start up. You
will need to provide a configurator instance to the application context. More on
configurators later.

```objective-c
//Initialize a configurator
id<OCSConfigurator> configurator = [[OCSConfiguratorFromClass alloc] initWithClass:[YourObjectFactory class]];

//Initialize the application context with the configurator
OCSApplicationContext *context = [[OCSApplicationContext alloc] initWithConfigurator:configurator];

//Start the context
[context start];

//Done! Well...
```

### Using the *OCSConfiguratorFromClass*

*TODO rewrite when less tired*. This is a ready-made configurator implementation. It uses the information found in a class
provided by you through introspection. The provided class will also serve as the creator
of your objects, hence we will call it a factory class. The idea behind this is to give you a programatic and testable
configuration. This makes the use of external configuration files and/or macros obsolete.

#### Dealing with larger applications

In larger applications, the factory class can quickly become huge. This is where you can
and should use Objective C's
[category](http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/objectivec/chapters/occategories.html "Objective-C programming language reference")
mechanism. For each logical group of objects you can create a category, named after this
logical group. All methods in all categories of your factory class will be taken into
account. TODO give some category name examples...

Reliant identifies 2 kinds of scope for an object: singletons and prototypes. (*These
names are taken from the well know design patterns*)

- A singleton is a stateless shared object, which is created only once (might be more then
once cfr. memory warnings). Objects created as singleton should be thread safe!

- A prototype will be created each time it is requested from the application context. Be
carefull though! If you inject a prototype into a singleton, the prototype's livecycle is
bound to the singleton!

#### Creating singletons with your factory class

For each singleton you need, you should add a method with the following signature:

```objective-c
- (id) createSingletonFoo {
	return [[[Foo alloc] init] autorelease];
}
```

You can also use what is called *constructor injection* by calling another 
*createSingleton* method:

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

#### Creating prototypes with your factory class

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
- (NSSet *) aliasesForFoo {
	return [NSSet setWithObjects:@"_foo", @"_fuu", nil];
}
```

*Remark:* by default, two aliases are already registered for each object. They take the
form of the key in uppercase (eg. FOO, BAR, ...) and the key starting with a lowercase
(eg. foo, bar, ...). Aliases must be unique, and should also never be equal to an object
key. If an attempt is made to add a duplicate, an exception will be raised.

#### Other methods in your factory class

You can add other methods, which might help in creating your objects. These will be
ignored by the framework, but you can obviously use them in your create methods.

### Injection

All objects created in the application context will be injected after their creation. This
is done by using Objective-C's [KVC](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html "Key-Value Coding Programming Guide")
mechanism. Reliant will scan your object's properties. If a writable property's name
matches with a key or alias for an object in the application context, and if it's current
value is nil, the matching object will be injected in this property. All other properties
will be left alone.

#### Injecting objects that are not know to the application context

You can use the injection mechanism described above on objects which are not setup in the 
application context. A good example would be a UIViewController. This is what you need to do:

```objective-c
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
```

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

*Remark* Although the framework is extendible, we encourage the use of the provided
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