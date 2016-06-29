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
The parent object context. Maybe nil
*/
@property(nonatomic, readonly, weak, nullable) id<OCSObjectContext> parentContext;

/**
The name of this context as configured by it's configurator.
*/
@property(nonatomic, readonly, nonnull)  NSString * name;

/**
Returns the object identified by the given key (might be an alias too). If an object for the given key (or an alias) is not found on the current context, the parent context is consulted. If the object is not found in this context or any of parnet contexts in its hierarchy, nil is returned.

@param key the key
*/
- (nullable id)objectForKey:(nonnull NSString *)key;

/**
Call this method if you want to inject an object with objects known in the context. Injection is always done by properties here. ALL properties in your instance will be tried. If a matching object (by name AND type) is found, it is injected.

@param object the object to be injected
*/
- (void)performInjectionOn:(nonnull id)object;

/**
Bootstrap the application context. This will load object definitions via the given configurator. Eager singletons will be loaded as well. Loads any necessary resources, and notifies the configurator that it has been loaded.
*/
- (BOOL)start;

@end

/**
An dependency injection (DI) context.

Objects that are not in the DI context can still obtain objects on the DI context using this class through manual look (via OCSObjectContext::objectForKey) or via the automatic injection mechanism (prefer this on, via OCSObjectContext::performInjectionOn:).
 
About parent contexts:
A context can have a parentContext. If you want your context to have a parent, it must be known during initialization. There are two ways to specify a parent context:
 - Via a parentContext parameter through one of the initializers. You may pass nil, but of course this will result in a so called root context (a context without a parent context)
 - Via the configurator: if your configurator returns a non-nil parentContextName, the context by that name will be looked up in the context registry, and will be used as parent. If a context by that name cannot be found, an exception will be raised.
 
The first option is the prefered option as of reliant 2.4, since it avoids ordering issues. The issue is explained here in case you get the above mentioned exception, but don't understand why.
 Let's assume we have a UINavigationController and we want to bind a context on it, in order to have common objects for the entire navigation stack. 
 Now, to initialize the navigation controller, we need to use the initWithRootViewController:, suggesting that we should first initialize another view controller. If we 
 initialize that view controller, and try to bind a context to it, that would already refer to the navigation controller context, we could get the exception, as we did not yet initialize the navigation controller, nor did we bind the root context to it.
 
The take away from this is: if you have a reference to the parent context directly, then use it to initialize a child context throught the initWith...:parentContext: variants.
*/
@interface OCSObjectContext : NSObject<OCSObjectContext>

/**
 The scope factory, used to retrieve scopes based on the definitions found in this object context's configurator.

 @see OCSConfigurator
 @see OCSDefinition
 */
@property(nonatomic, readonly, nonnull) id <OCSScopeFactory> scopeFactory;

/**
 Convenience initializer. Prepares the object context with the given configurator. Sets the scope factory to an instance of OCSDefaultScopeFactory and  the context registry to OCSDefaultContextRegistry shared instance.
 
 @param configurator The configurator that will be used to setup the context.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator;

/**
 Convenience initializer. Prepares the object context with the given configurator. Sets the scope factory to an instance of OCSDefaultScopeFactory and  the context registry to OCSDefaultContextRegistry shared instance.
 
 @param configurator The configurator that will be used to setup the context.
 @param parentContext The parent context for this new context. A context has access to all its parent context objects.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator parentContext:(nullable id<OCSObjectContext>)parentContext;

/**
 Convenience initializer. Prepares the object context with the given configurator. Sets the scope factory to an instance of OCSDefaultScopeFactory, the context registry to OCSDefaultContextRegistry shared instance and registers the context linked to it's bound object.
 
 @param configurator The configurator that will be used to setup the context.
 @param boundObject  The object to which this context is bound. Defaults to nil, but you should probably not rely on this default.
 */

- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator boundObject:(nullable NSObject*)boundObject;
/**
 Convenience initializer. Prepares the object context with the given configurator. Sets the scope factory to an instance of OCSDefaultScopeFactory, the context registry to OCSDefaultContextRegistry shared instance and registers the context linked to it's bound object.
 
 @param configurator The configurator that will be used to setup the context.
 @param boundObject  The object to which this context is bound. Defaults to nil, but you should probably not rely on this default.
 @param parentContext The parent context for this new context. A context has access to all its parent context objects.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator boundObject:(nullable NSObject*)boundObject parentContext:(nullable id<OCSObjectContext>)parentContext;

/**
 Convenience initializer. Prepares the object context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.

 @param configurator The configurator that provides object definitions and the object factory.
 @param scopeFactory The factory used to look up scopes.
 @param contextRegistry The context registry to which this context should be recorded.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator scopeFactory:(nonnull id <OCSScopeFactory>)scopeFactory contextRegistry:(nonnull id<OCSContextRegistry>)contextRegistry;

/**
 Convenience initializer. Prepares the object context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.
 
 @param configurator The configurator that provides object definitions and the object factory.
 @param scopeFactory The factory used to look up scopes.
 @param contextRegistry The context registry to which this context should be recorded.
 @param parentContext The parent context for this new context. A context has access to all its parent context objects.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator scopeFactory:(nonnull id <OCSScopeFactory>)scopeFactory contextRegistry:(nonnull id<OCSContextRegistry>)contextRegistry parentContext:(nullable id<OCSObjectContext>)parentContext;

/**
 Convenience initializer. Prepares the object context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.
 
 @param configurator The configurator that provides object definitions and the object factory.
 @param scopeFactory The factory used to look up scopes.
 @param contextRegistry The context registry to which this context should be recorded.
 @param boundObject The object to which this context is bound. Defaults to nil, but you should probably not rely on this default.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator scopeFactory:(nonnull id <OCSScopeFactory>)scopeFactory contextRegistry:(nonnull id <OCSContextRegistry>)contextRegistry boundObject:(nullable NSObject *)boundObject;

/**
 Designated initializer. Prepares the object context with the given configurator and the given scope factory. Each different context should have it's own configurator instance, and it's own scope factory. You should never share configurators and scope factories between contexts.
 
 @param configurator The configurator that provides object definitions and the object factory.
 @param scopeFactory The factory used to look up scopes.
 @param contextRegistry The context registry to which this context should be recorded.
 @param boundObject The object to which this context is bound. Defaults to nil, but you should probably not rely on this default.
 @param parentContext The parent context for this new context. A context has access to all its parent context objects.
 */
- (nonnull instancetype)initWithConfigurator:(nonnull id <OCSConfigurator>)configurator scopeFactory:(nonnull id <OCSScopeFactory>)scopeFactory contextRegistry:(nonnull id <OCSContextRegistry>)contextRegistry boundObject:(nullable NSObject *)boundObject parentContext:(nullable id<OCSObjectContext>)parentContext;

@end
