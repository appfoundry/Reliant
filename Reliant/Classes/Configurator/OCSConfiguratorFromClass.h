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
Implement this property on your factory class when you want a custom name for the context you are configuring with this configuration class. If you don't implement this property the name will be derived from the class name suffixed with "Context".
*/
@property (nonatomic, readonly) NSString *contextName;

/**
Implement this property on your factory class when you want the configured OCSObjectContext to have a parent context. The return name should match the name of a context already known to Reliant. An exception should be thrown when the given name doesn't match the name of a known context.
*/
@property (nonatomic, readonly) NSString *parentContextName;

/**
@warning Deprecated: You should no longer use this method to configure a parent context. Use the parentContextName property instead.
*/
- (Class)parentContextConfiguratorClass __attribute__((deprecated));



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
