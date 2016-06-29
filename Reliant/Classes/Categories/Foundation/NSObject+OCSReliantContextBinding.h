//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

/**
This category supplies a convenient way to bootstrap an object context and bind it to an object instance.
*/
@interface NSObject (OCSReliantContextBinding)

/**
The bound object context on this instance.

Returns nil if no context was bound yet.
*/
@property (nonatomic, strong) id<OCSObjectContext> ocsObjectContext;

/**
Bootstraps and binds an object context, configured based on the given factory class, to this instance.

@param factoryClass the factory class to be used as factory and configuration for bound context.
@see OCSConfiguratorFromClass
*/
- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class) factoryClass;


/**
 Bootstraps and binds an object context with the given parent context, configured based on the given factory class, to this instance.
 
 @param factoryClass the factory class to be used as factory and configuration for bound context.
 @param parentContext the parent context for bound context.
 @see OCSConfiguratorFromClass
 */
- (void)ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:(Class) factoryClass parentContext:(id<OCSObjectContext>)parentContext;

@end