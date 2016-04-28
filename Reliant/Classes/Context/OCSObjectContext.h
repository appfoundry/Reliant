//
//  OCSObjectContext.h
//  Reliant
//
//  Created by Michael Seghers on 2/05/12.
//  Copyright (c) 2012 AppFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCSConfigurator;
@protocol OCSScope;
@protocol OCSObjectFactory;
@protocol OCSScopeFactory;

@class OCSObjectContext;
@protocol OCSContextRegistry;

/**
@warning Deprecated: You should nog longer use OCSApplicationContext as type. It has been renamed to OCSObjectContext.
*/
typedef OCSObjectContext OCSApplicationContext __attribute__((deprecated));


@protocol OCSObjectContext

/**
The parent object context.
*/
@property(nonatomic, readonly, weak) id<OCSObjectContext> parentContext;

/**
The name of this context as configured by it's configurator.
*/
@property(nonatomic, readonly) NSString *name;

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

/**
An dependency injection (DI) context.

Initialize an instance using the designated init method OCSObjectContext::initWithConfigurator:

Objects that are not in the DI context can still obtain objects on the DI context using this class through manual look (via OCSObjectContext::objectForKey) or via the automatic injection mechanism (prefer this on, via OCSObjectContext::performInjectionOn:).
*/
@interface OCSObjectContext : NSObject<OCSObjectContext>

/**
The scope factory, used to retrieve scopes based on the definitions found in this object context's configurator.

@see OCSConfigurator
@see OCSDefinition
*/
@property(nonatomic, readonly) id <OCSScopeFactory> scopeFactory;

/**
Designated initializer. Prepares the object context with the given configurator. Sets the scope factory to an instance of OCSDefaultScopeFactory and  the context registry to OCSDefaultContextRegistry shared instance.

@param configurator The configurator that will be used to setup the context.
*/
- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator;

/**
Convenience initializer. Prepares the object context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.

@param configurator The configurator that provides object definitions and the object factory.
@param scopeFactory The factory used to look up scopes.
@param contextRegistry The context registry to which this context should be recorded.
*/
- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator scopeFactory:(id <OCSScopeFactory>)scopeFactory contextRegistry:(id<OCSContextRegistry>)contextRegistry;

- (instancetype)initWithConfigurator:(id <OCSConfigurator>)configurator scopeFactory:(id <OCSScopeFactory>)scopeFactory contextRegistry:(id <OCSContextRegistry>)contextRegistry boundObject:(NSObject *)boundObject;
@end
