//
// Created by Michael Seghers on 22/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSScopeFactory.h"

/**
An OCSScopeFactory which will be used by default if you don't provide your own implementation when initializing an
object context.

It returns:
- OCSSingletonScope if the name is `singleton`
- OCSPrototypeScope if the name is `prototype`
- OCSSingletonScope as default, if the given name is not `singleton` or `prototype

@see OCSObjectContext
*/
@interface OCSDefaultScopeFactory : NSObject<OCSScopeFactory>
@end