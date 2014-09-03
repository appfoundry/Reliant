//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

/**
An OCSBoundContextLocator which locates an object context on the given object. If it has no bound context, nil is returned.
*/
@interface OCSBoundContextLocatorOnGivenObject : NSObject<OCSBoundContextLocator>
@end