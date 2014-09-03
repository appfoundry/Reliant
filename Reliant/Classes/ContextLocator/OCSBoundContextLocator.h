//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>

@protocol OCSObjectContext;

/**
A bound context locator tries to locate an object context for the given object.

@see NSObject(OCSReliantContextBinding)
@see OCSObjectContext
*/
@protocol OCSBoundContextLocator <NSObject>

/**
Locate an object context for the given object. Depending on the implementation the context might be found on the object
itself, on some related object (like parent child relation), or on a general application specific object. See specific
implementations for more details.

@param object the object which is used to search for a bound context.
*/
- (id <OCSObjectContext>)locateBoundContextForObject:(NSObject *)object;

@end