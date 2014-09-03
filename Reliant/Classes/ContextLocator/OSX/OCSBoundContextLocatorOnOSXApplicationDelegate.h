//
// Created by Michael Seghers on 28/08/14.
//

#import <Foundation/Foundation.h>
#import "OCSBoundContextLocator.h"

/**
An OCSBoundContextLocator which locates an object context on the NSApplication delegate for the currently running OS X
application. Obviously, this locator is excluded for iOS builds.
*/
@interface OCSBoundContextLocatorOnOSXApplicationDelegate : NSObject<OCSBoundContextLocator>
@end