//
// Created by Michael Seghers on 01/09/14.
//

#import <Foundation/Foundation.h>
#import "OCSContextRegistry.h"


/**
An OCSContextRegistry which will be used by default if you don't provide your own implementation when initializing an
object context

@see OCSObjectContext
*/
@interface OCSDefaultContextRegistry : NSObject<OCSContextRegistry>

/**
Returns the singleton instance.
*/
+ (instancetype)sharedDefaultContextRegistry;

@end