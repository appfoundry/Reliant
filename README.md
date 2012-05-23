Reliant
=======

Reliant is a dependency injection framework for Objective C, specifically targeted, but 
not limited to, for iOS. It's goal is to make it's use as simple as possible, while not 
limiting it's possibilities. It aims to have as little impact as possible on your project 
code.

The motivation for this library came from being used to a highly testable infrastructure 
in other languages thanks to DI. Although factories and mock libraries provide a fairly 
nice solution, the pure loose coupling is never reached, since you still have a dependency 
to a factory in almost all classes in your project. Before starting this library, I looked 
for opinions about DI in dynamic languages at the one hand, and in frontend driven 
solutions at the other hand. Reliant is an answer to these questions.

Quick start
-----------

### Bootstrapping Reliant

To get started with Reliant, you need to tell the *OCSApplicationContext* to start up. You
will need to provide a configurator instance to the application context. More on configurators later.

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

This is a ready-made configurator implementation. It uses the information found in a class
provided by you through introspection. The provided class will also serve as the creator of your objects. The
idea behind this is to give you a programatic and testable configuration. This makes the
use of external configuration files and/or macros obsolete.

TODO describe category feature

Reliant identifies 2 kinds of objects: singletons and prototypes. (*These names are taken
from the well know design patterns*) 

- A singleton is a stateless shared object, which is
created only once (might be more then once cfr. memory warnings). Objects created as
singleton should be thread safe! 

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



### The configurator

A configurator is responsible for setting up definitions and creating object instance
based on those definitions. Although a default class configurator
(*OCSConfiguratorFromClass*) is provided by Reliant, you can always build your own. Your
custom configurator should conform to the *OCSConfigurator* protocol. In the
configurator's designated initializer, you should start building your object definitions.
A configurator, although not enforced, should maintain it's own definition registry. A
configurator should not start creating instances for these definitions just until the
contextLoaded: message is send to it. Only after all work is done should the configurator
return objects through its objectForKey:inContext: method. When work is done, the
initializing property should be true/YES/whatever-other-bool-literal-is-available

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