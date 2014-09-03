//
//  OCSConfiguratorFromClass.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//



#import "OCSConfiguratorBase.h"

/**
An implicit protocol for factory classes used for configuring OCSObjectContexts using an OCSConfiguratorFromClass.
*/
@protocol OCSConfigurationClass

@optional
/**
Implement this method on your factory class when you want the configured OCSObjectContext to have a parent context. The class you return is the factory class for that context.
*/
- (Class)parentContextConfiguratorClass;

@end

/**
Configurator implementation which derives definitions from methods in a given class instance. The class instance is also used as object factory.

The given class is called a factory class throughout Reliant's documentation.

@see OCSObjectFactory
*/
@interface OCSConfiguratorFromClass : OCSConfiguratorBase

/**
Designated initializer. Creates OCSDefinition instances depending on methods found in the factoryClass.

The factory class methods returning an id, without arguments and starting with createSingleton, createEagerSingleton and createPrototype are evaluated. The remainder of the method name is taken as the definition's key.

The configured context will get a name based on the specified class.

@param factoryClass the factory class. This class holds methods for creating singletons and prototypes as well as methods to define aliases for these singletons and prototypes.
@return self
*/
- (id)initWithClass:(Class)factoryClass;

@end
