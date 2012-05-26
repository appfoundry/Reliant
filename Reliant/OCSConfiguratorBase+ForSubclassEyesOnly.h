//
//  OCSConfiguratorBase+ForSubclassEyesOnly.h
//  Reliant
//
//  Created by Michael Seghers on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCSConfiguratorBase.h"

@class OCSDefinition;

/**
 When creating subclasses of the OCSConfiguratorBase, you should import this header file in it's implementation. The configurator base will guard the initializing state, and automatically bootstrap eager singletons for you. The objectForKey:inContext: method is templated to call the internalObjectForKey:inContext: and the contextLoaded: method will call the internalContextLoaded: These methods are your hooks to do more work specific to your own configurator. This header file should never be used outside a subclass implementation. It's methods should also never be called from outside a subclass.
 */
@interface OCSConfiguratorBase (ForSubclassEyesOnly)

@property (nonatomic, readwrite) BOOL initializing;

/**
 Call this method for each definition you have in your configurator.
 
 @param definition The definition to register.
 
 @see OCSDefinition
 */
- (void) registerDefinition:(OCSDefinition *) definition;

/**
 Get a definiation for the given key or alias.
 
 @param keyOrAlias the key or alias of the definition you are looking for
 
 @return the definition with the given key or alias, or nil if no such definition exists.
 */
- (OCSDefinition *) definitionForKeyOrAlias:(NSString *) keyOrAlias;

/**
 Templated method. Will always attempt a lookup, even if still initializing. This is ok since internally we know what we are doing. This method is called from the objectForKey:inContext: method.
 
 @param key the key
 @param context the application context this configurator belongs to.
 
 @return the object with the given key, or nil if not found
 
 @see OCSConfigurator::objectForKey:inContext:
 */
- (id) internalObjectForKey:(NSString *)key inContext:(OCSApplicationContext *)context;

/**
 Templated method. Will be called from the contextLoaded: method.
 
 @param context the application context this configurator belongs to.
 */
- (void) internalContextLoaded:(OCSApplicationContext *) context;

@end
