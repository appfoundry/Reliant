//
// Created by Michael Seghers on 23/08/14.
//

#import <Foundation/Foundation.h>

/**
Runtime helper class.

This class is private API.
*/
@interface OCSRuntimeMagic : NSObject

/**
Copy a property from one class to another (copies the implementation from one class to another). Method is sensitive to
preconditions that must be met in order to be able to do this. Please respect the fact that this is private API.

@param name the name of the property to be copied
@param origin the source class, which holds the property to be copied.
@param destination the destination class, which should receive the property.
*/
+ (void) copyPropertyNamed:(NSString *) name fromClass:(Class) origin toClass:(Class) destination;

@end