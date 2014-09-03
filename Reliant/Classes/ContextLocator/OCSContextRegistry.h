//
// Created by Michael Seghers on 01/09/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

/**
A context registry holds weak references to known contexts. Each time a context is created, it registers itself with
this registry. This is used when a context looks up its configured parent context.

@see OCSObjectContext
*/
@protocol OCSContextRegistry <NSObject>

/**
Adds the given context to this registry, identifying it by its name.

Implementations should make sure the given context is not retained.

@param context the context to register
@see OCSObjectContext::name
*/
- (void)registerContext:(id <OCSObjectContext>)context;

/**
Returns a context for the given name.

Return nil if the context cannot be found.

@param name The name of the context to look for.
*/
- (id<OCSObjectContext>)contextForName:(NSString *)name;

@end