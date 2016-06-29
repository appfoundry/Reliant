//
//  OCSBootstrapper.h
//  Reliant
//
//  Created by Michael Seghers on 01/06/16.
//
//

#import <Foundation/Foundation.h>
#import "OCSObjectContext.h"

@protocol OCSBootstrapper <NSObject>

/**
 Bootstrap a context, configured by the given configuration class and bind it on the given object.
 
 @param configuration the OCSConfigurationClass to use as configuration
 @param object the object to bind the context on
 */
- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindOnObject:(NSObject *)object;

/**
 Bootstrap a context, configured by the given configuration class, bind it on the given object and inject the given object with the objects from the bootstrapped context.
 
 @param configuration the OCSConfigurationClass to use as configuration
 @param object the object to bind the context on, and to be injected
 */
- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindAndInjectObject:(NSObject *)object;

/**
 Bootstrap a context, configured by the given configuration class and bind it on the given object. The context receives the given parentContext as parent context.
 
 @param configuration the OCSConfigurationClass to use as configuration
 @param object the object to bind the context on
 @param parentContext the parent context of the bootstrapped context
 */
- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindOnObject:(NSObject *)object parentContext:(id<OCSObjectContext>)parentContext;

/**
 Bootstrap a context, configured by the given configuration class, bind it on the given object and inject the given object with the objects from the bootstrapped context. The context receives the given parentContext as parent context.
 
 @param configuration the OCSConfigurationClass to use as configuration
 @param object the object to bind the context on, and to be injected
 @param parentContext the parent context of the bootstrapped context
 */
- (id<OCSObjectContext>)bootstrapObjectContextWithConfigurationFromClass:(Class)configuration bindAndInjectObject:(NSObject *)object parentContext:(id<OCSObjectContext>)parentContext;

@end
