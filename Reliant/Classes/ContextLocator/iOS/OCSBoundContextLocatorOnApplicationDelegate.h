//
// Created by Michael Seghers on 24/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

/**
An OCSBoundContextLocator which locates an object context on the UIApplication delegate for the currently running iOS
application. Obviously, this locator is excluded for OSX builds.
*/
@interface OCSBoundContextLocatorOnApplicationDelegate : NSObject<OCSBoundContextLocator>

@end