//
//  OCSObjectContext.h
//  Reliant
//
//  Created by Michael Seghers on 2/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//


@protocol OCSConfigurator;
@protocol OCSScope;
@protocol OCSObjectFactory;
@protocol OCSScopeFactory;

@class OCSObjectContext;

/**
@warning Deprecated: You should nog longer use OCSApplicationContext as type. It has been renamed to OCSObjectContext.
*/
typedef OCSObjectContext OCSApplicationContext __attribute__((deprecated));

/**
The application's dependency injection (DI) context. To bootstrap Reliant, you should use this class, or one of it's derivatives.

Initialize an instance using the designated init method OCSObjectContext::initWithConfigurator:

Objects that are not in the DI context can still obtain objects on the DI context using this class.

@author Mike Seghers
*/
@interface OCSObjectContext : NSObject

@property(nonatomic, readonly) id <OCSScopeFactory> scopeFactory;

/**
The parent application context.
*/
@property(nonatomic, weak) OCSObjectContext *parentContext;

/**
Designated initializer. Prepares the application context with the given configurator.

@param configurator The configurator that will be used to setup the context.
*/
- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator;

/**
Convenience initializer. Prepares the application context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.

@param configurator The configurator that provides object definitions and the object factory.
@param scopeFactory The factory used to look up scopes.
*/
- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator scopeFactory:(id <OCSScopeFactory>)scopeFactory;

/**
Returns the object identified by the given key (might be an alias too). If an object for the given key (or an alias) is not found on the current context, the parent context is consulted. If not parent context exists and the object is not found, nil is returned.

@param key the key
*/
- (id)objectForKey:(NSString *)key;

/**
Call this method if you want to inject an object with objects known in the context. Injection is always done by properties here. ALL properties in your instance will be tried. If a matching object (by name AND type) is found, it is injected.

@param object the object to be injected
*/
- (void)performInjectionOn:(id)object;

/**
Bootstrap the application context. This will load object definitions via the given configurator. Eager singletons will be loaded as well. Loads any necessary resources, and notifies the configurator that it has been loaded.
*/
- (BOOL)start;

@end
