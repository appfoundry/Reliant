//
//  OCSConfiguratorFromClass.h
//  Reliant
//
//  Created by Michael Seghers on 6/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//



#import "OCSConfiguratorBase.h"

/**
 Configurator implementation which derives definitions from methods in a given class instance. The class instance is also used to create object instances.
 
 TODO Write on how to make a configurator class
 
 @author Mike Seghers
 */
@interface OCSConfiguratorFromClass : OCSConfiguratorBase

/**
 Designated initializer. Creates OCSDefinition instances depending on methods found in the factoryClass.
 
 The factory class methods returning an id, without arguments and starting with createSingleton, createEagerSingleton and createPrototype are evaluated. The remainder of the method name is taken as the definition's key.

 The configured context will get a name based on the specified class. If you don't want this default behaviour, you should add a method called contextName which returns a string, holding the desired name.
 
 @param factoryClass the factory class. This class holds methods for creating singletons and prototypes as well as methods to define aliases for these singletons and prototypes.
 @return self
 */
- (id)initWithClass:(Class) factoryClass;

@end
